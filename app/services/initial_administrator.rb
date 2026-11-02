# Crea la primera cuenta administradora (GL-02, D-GL02-6; D1, AM-5).
#
# Se niega si ya hay un administrador activo. La comprobación y la creación
# ocurren dentro de una transacción con un bloqueo consultivo de PostgreSQL,
# para que dos ejecuciones simultáneas no creen dos administradores.
class InitialAdministrator
  LOCK_KEY = 4_702_202_611 # identificador fijo del bloqueo consultivo
  ALREADY_EXISTS = "Ya existe un administrador activo.".freeze
  PASSWORDS_DIFFER = "Las contraseñas no coinciden.".freeze

  Result = Data.define(:user, :errors) do
    def success? = errors.empty?
  end

  def self.acquire_lock!
    ActiveRecord::Base.connection.execute("SELECT pg_advisory_xact_lock(#{LOCK_KEY})")
  end

  def self.create(email_address:, name:, password:, password_confirmation:)
    return Result.new(user: nil, errors: [ PASSWORDS_DIFFER ]) unless password == password_confirmation

    User.transaction do
      acquire_lock!
      next Result.new(user: nil, errors: [ ALREADY_EXISTS ]) if User.active.where(admin: true).exists?

      user = User.new(email_address: email_address, name: name, password: password, admin: true)
      user.save ? Result.new(user: user, errors: []) : Result.new(user: nil, errors: user.errors.full_messages)
    end
  end
end
