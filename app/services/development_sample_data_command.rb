# Interfaz de línea de comandos del conjunto ficticio (GL-08). Informa cada
# clave creada o existente; nunca muestra contraseñas.
class DevelopmentSampleDataCommand
  REFUSED = "Solo se puede ejecutar en desarrollo (RAILS_ENV=development). No se consultó ni modificó la base.".freeze

  def initialize(service: DevelopmentSampleData.new, output: $stdout)
    @service = service
    @output = output
  end

  def call
    result = @service.call

    case result.status
    when :refused
      @output.puts REFUSED
      1
    when :conflict
      result.conflicts.each { |conflict| @output.puts "Conflicto: #{conflict}" }
      @output.puts "No se creó ni modificó ningún registro."
      1
    else
      result.created.each { |key| @output.puts "creado #{describe(key)}" }
      result.existing.each { |key| @output.puts "ya existía #{key}" }
      @output.puts "#{result.created.size} creados, #{result.existing.size} existentes."
      @output.puts "Las cuentas nuevas no tienen una contraseña conocida: establecela con " \
                   "bin/rails growth_log:contrasena_ficticia EMAIL=<correo>." if result.created.any? { |k| k.start_with?("account:") }
      0
    end
  end

  private
    def describe(key)
      account = DevelopmentSampleData::ACCOUNTS.find { |a| a[:key] == key }
      account ? "#{key} #{account[:email]} (#{account[:name]})" : key
    end
end
