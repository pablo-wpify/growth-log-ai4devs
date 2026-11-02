# Almacén de los límites de intentos de inicio de sesión (GL-02, D-GL02-4).
#
# Implementa la parte de la interfaz de ActiveSupport::Cache que usan
# `rate_limit` y EmailLoginThrottle (increment, read, delete) sobre una tabla de
# PostgreSQL. El incremento es un único INSERT ... ON CONFLICT, atómico entre
# procesos e instancias. La ventana es fija: empieza con el primer incremento y
# se reinicia cuando vence. Se reemplazó a FileStore porque sus incrementos no
# son atómicos entre procesos (escribe con archivo temporal y renombrado).
class LoginAttemptStore
  INCREMENT_SQL = <<~SQL.squish
    INSERT INTO login_attempt_counters (key, count, expires_at)
    VALUES (:key, :amount, :expires_at)
    ON CONFLICT (key) DO UPDATE SET
      count = CASE WHEN login_attempt_counters.expires_at <= :now
                   THEN EXCLUDED.count
                   ELSE login_attempt_counters.count + EXCLUDED.count END,
      expires_at = CASE WHEN login_attempt_counters.expires_at <= :now
                        THEN EXCLUDED.expires_at
                        ELSE login_attempt_counters.expires_at END
    RETURNING count
  SQL

  def increment(key, amount = 1, expires_in:, **)
    now = Time.current
    LoginAttemptCounter.where(expires_at: ..now).delete_all
    sql = ActiveRecord::Base.sanitize_sql([ INCREMENT_SQL, key: key.to_s, amount: Integer(amount), expires_at: now + expires_in, now: now ])
    LoginAttemptCounter.connection.select_value(sql)
  end

  def read(key, **)
    LoginAttemptCounter.where(key: key.to_s).where("expires_at > ?", Time.current).pick(:count)
  end

  def delete(key, **)
    LoginAttemptCounter.where(key: key.to_s).delete_all.positive?
  end
end
