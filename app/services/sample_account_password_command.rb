# Establece la contraseña de una cuenta del conjunto ficticio (GL-08, P-14).
#
# Solo en desarrollo y solo para cuentas marcadas por la tarea de datos
# ficticios. El correo sale de EMAIL o se pide; la contraseña se pide dos
# veces sin eco (SecretPrompt), nunca de argumentos ni variables. En una
# transacción cambia el hash y elimina todas las sesiones de la cuenta. No
# cambia estado, rol ni nombre: una cuenta desactivada sigue desactivada.
class SampleAccountPasswordCommand
  NOT_SAMPLE = "No es una cuenta del conjunto ficticio.".freeze

  def initialize(input: $stdin, output: $stdout, env: ENV, rails_env: Rails.env)
    @input = input
    @output = output
    @env = env
    @rails_env = rails_env
  end

  def call
    unless @rails_env.development?
      @output.puts DevelopmentSampleDataCommand::REFUSED
      return 1
    end

    email = @env["EMAIL"].presence || ask("Correo: ")
    user = sample_user(email.to_s)
    return fail_with(NOT_SAMPLE) unless user

    prompt = SecretPrompt.new(input: @input, output: @output)
    password = prompt.ask("Contraseña nueva (mínimo #{User::PASSWORD_MIN_LENGTH} caracteres): ")
    confirmation = prompt.ask("Repetí la contraseña: ")
    return fail_with("No se recibió la contraseña.") if password.nil? || confirmation.nil?
    return fail_with("Las contraseñas no coinciden.") unless password == confirmation

    user.password = password
    return fail_with(*user.errors.full_messages_for(:password)) unless user.valid?

    closed = User.transaction do
      user.save!
      user.sessions.delete_all
    end

    @output.puts "Contraseña actualizada para #{user.email_address}. Sesiones cerradas: #{closed}."
    @output.puts "La cuenta sigue desactivada: no puede iniciar sesión." unless user.active?
    0
  end

  private
    def sample_user(email)
      normalized = User.normalize_value_for(:email_address, email)
      SampleDataRecord.joins(:user).find_by(users: { email_address: normalized })&.user
    end

    def fail_with(*messages)
      messages.each { |message| @output.puts "Error: #{message}" }
      @output.puts "No se cambió ninguna contraseña."
      1
    end

    def ask(prompt)
      @output.print prompt
      @input.gets&.chomp
    end
end
