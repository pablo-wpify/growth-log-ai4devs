# Límite de intentos fallidos de inicio de sesión por correo (GL-02, D-GL02-4).
#
# Cuenta solo fallos, en una ventana fija de 15 minutos que empieza con el
# primer fallo; un inicio de sesión exitoso reinicia el conteo. La clave usa el
# SHA-256 del correo normalizado como en User: no guarda el correo en claro.
#
# Riesgo que no elimina: quien conozca un correo puede provocar los fallos e
# impedir temporalmente el acceso de esa persona.
class EmailLoginThrottle
  LIMIT = 5
  WINDOW = 15.minutes

  def initialize(email_address, store: LoginAttemptStore.new)
    normalized = User.normalize_value_for(:email_address, email_address.to_s)
    @key = "login-failures:#{Digest::SHA256.hexdigest(normalized)}"
    @store = store
  end

  def blocked?
    @store.read(@key).to_i >= LIMIT
  end

  def record_failure!
    @store.increment(@key, 1, expires_in: WINDOW)
  end

  def reset!
    @store.delete(@key)
  end
end
