# Interfaz de línea de comandos del conjunto demo (GL-10). Informa cada clave
# creada o existente; nunca muestra contraseñas ni hashes.
class DemoDataCommand
  REFUSED = "Solo se puede ejecutar en la instancia demo (RAILS_ENV=production y " \
            "#{DemoData::INSTANCE_VARIABLE} con su valor exacto). No se consultó ni modificó la base.".freeze

  def initialize(service: DemoData.new, output: $stdout)
    @service = service
    @output = output
  end

  def call
    result = @service.call

    case result.status
    when :refused
      @output.puts REFUSED
      1
    when :conflict, :invalid
      result.errors.each { |error| @output.puts "Error: #{error}" }
      @output.puts "No se creó ni modificó ningún registro."
      1
    else
      result.created.each { |key| @output.puts "creado #{describe(key)}" }
      result.existing.each { |key| @output.puts "ya existía #{key}" }
      @output.puts "#{result.created.size} creados, #{result.existing.size} existentes."
      0
    end
  end

  private
    def describe(key)
      account = DemoData::ACCOUNTS.find { |a| a[:key] == key }
      account ? "#{key} #{account[:email]} (#{account[:name]})" : key
    end
end
