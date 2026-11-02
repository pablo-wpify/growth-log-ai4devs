# Límite de intentos fallidos de inicio de sesión por correo (GL-02, D-GL02-4).
#
# Como máximo LIMIT intentos fallidos por correo en una ventana fija de 15
# minutos, también con peticiones simultáneas. Cada intento reserva un lugar
# con un incremento atómico (un único UPSERT en PostgreSQL) ANTES de evaluar
# las credenciales: solo se evalúa si la reserva queda dentro del límite. Un
# intento exitoso reinicia el conteo; uno fallido conserva su reserva, que es
# el fallo contado. La clave usa el SHA-256 del correo normalizado como en
# User: no guarda el correo en claro.
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

  # Reserva atómicamente un intento. Devuelve false si supera el límite: en ese
  # caso no hay que evaluar las credenciales.
  def reserve_attempt
    @store.increment(@key, 1, expires_in: WINDOW) <= LIMIT
  end

  def reset!
    @store.delete(@key)
  end
end
