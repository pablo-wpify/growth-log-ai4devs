# Contadores de los límites de intentos de inicio de sesión (GL-02, D-GL02-4).
# Compartidos entre procesos e instancias; las claves son hashes, sin correo
# ni IP en claro.
class CreateLoginAttemptCounters < ActiveRecord::Migration[8.1]
  def change
    create_table :login_attempt_counters, id: false do |t|
      t.string :key, null: false, primary_key: true
      t.integer :count, null: false
      t.datetime :expires_at, null: false
    end
    add_index :login_attempt_counters, :expires_at
  end
end
