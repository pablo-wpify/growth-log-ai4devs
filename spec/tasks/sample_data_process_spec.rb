require "rails_helper"
require "open3"

# Protección de entorno con procesos reales (GL-08). Ejecuta las tareas como
# procesos propios con RAILS_ENV=test y RAILS_ENV=production, conectados a
# la base de test (base de pruebas aislada, nunca la de desarrollo), y
# comprueba que se niegan sin cambiar la base. Las contraseñas de prueba y
# la de la base pasan por variables o la entrada; nunca se imprimen.
RSpec.describe "Tareas de datos ficticios en procesos fuera de desarrollo" do
  self.use_transactional_tests = false

  after do
    SampleDataRecord.delete_all
    Assignment.delete_all
    Session.delete_all
    User.delete_all
    Person.delete_all
  end

  let(:db) { ActiveRecord::Base.connection_db_config.configuration_hash }

  def process_env(rails_env)
    base = { "RAILS_ENV" => rails_env }
    return base if rails_env == "test"

    # Producción, dirigida a la base de test. config/database.yml toma la
    # contraseña de producción de GROWTH_LOG_DATABASE_PASSWORD.
    url = "postgresql://#{db[:username]}@#{db[:host]}:#{db[:port]}/#{db[:database]}"
    base.merge("DATABASE_URL" => url, "GROWTH_LOG_DATABASE_PASSWORD" => db[:password].to_s, "SECRET_KEY_BASE_DUMMY" => "1")
  end

  def run_task(task, rails_env, extra_env: {}, stdin: "")
    output, status = Open3.capture2e(process_env(rails_env).merge(extra_env), "bin/rails", task, stdin_data: stdin, chdir: Rails.root.to_s)
    [ output, status ]
  end

  def snapshot
    [ User.order(:id).map(&:attributes), Person.order(:id).map(&:attributes),
      Assignment.order(:id).map(&:attributes), SampleDataRecord.order(:id).map(&:attributes) ]
  end

  %w[test production].each do |rails_env|
    it "growth_log:datos_ficticios se niega con RAILS_ENV=#{rails_env} y no cambia la base" do
      create_user(email_address: "luis.lider@example.test") # un registro existente
      before = snapshot

      output, status = run_task("growth_log:datos_ficticios", rails_env)

      expect(status.exitstatus).to eq(1), output
      expect(output).to include("Solo se puede ejecutar en desarrollo")
      expect(snapshot).to eq(before)
    end
  end

  it "growth_log:contrasena_ficticia se niega con RAILS_ENV=test y no cambia la cuenta marcada" do
    run_sample_data
    elena = sample_user("account:elena")
    before = snapshot
    password = generated_password

    output, status = run_task("growth_log:contrasena_ficticia", "test",
      extra_env: { "EMAIL" => elena.email_address }, stdin: "#{password}\n#{password}\n")

    expect(status.exitstatus).to eq(1), output.gsub(password, "[OCULTA]")
    expect(output).to include("Solo se puede ejecutar en desarrollo")
    expect(output).not_to include(password)
    expect(snapshot).to eq(before)
  end
end
