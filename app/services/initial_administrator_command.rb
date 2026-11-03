# Interfaz de línea de comandos del administrador inicial.
#
# Correo y nombre salen de EMAIL y NOMBRE o se piden por la terminal (no son
# secretos). La contraseña se pide dos veces: sin eco cuando hay una terminal,
# o leída de la entrada estándar cuando no la hay. Nunca se lee de argumentos
# ni de variables de entorno, y nunca se escribe en la salida.
class InitialAdministratorCommand
  def initialize(input: $stdin, output: $stdout, env: ENV)
    @input = input
    @output = output
    @env = env
  end

  def call
    email = @env["EMAIL"].presence || ask("Correo: ")
    name = @env["NOMBRE"].presence || ask("Nombre: ")
    password = ask_secret("Contraseña (mínimo #{User::PASSWORD_MIN_LENGTH} caracteres): ")
    confirmation = ask_secret("Repetí la contraseña: ")

    if password.nil? || confirmation.nil?
      @output.puts "No se recibió la contraseña. No se creó ninguna cuenta."
      return 1
    end

    result = InitialAdministrator.create(email_address: email.to_s, name: name.to_s, password: password, password_confirmation: confirmation)

    if result.success?
      @output.puts "Administrador creado: #{result.user.email_address}"
      0
    else
      result.errors.each { |message| @output.puts "Error: #{message}" }
      @output.puts "No se creó ninguna cuenta."
      1
    end
  end

  private
    def ask(prompt)
      @output.print prompt
      @input.gets&.chomp
    end

    def ask_secret(prompt)
      SecretPrompt.new(input: @input, output: @output).ask(prompt)
    end
end
