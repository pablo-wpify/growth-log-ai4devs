require "rails_helper"
require "open3"

# Guarda de la instancia demo con procesos reales (GL-10). Ejecuta la tarea
# como proceso propio con distintos entornos, siempre conectado a la base de
# test (nunca a la de desarrollo ni a la de la demo) mediante DATABASE_URL.
# Las contraseñas de prueba y la de la base pasan por variables; nunca se
# imprimen.
RSpec.describe "Tarea de datos demo en procesos reales" do
  self.use_transactional_tests = false

  after do
    DemoDataRecord.delete_all
    FeedbackEntry.delete_all
    Assignment.delete_all
    Session.delete_all
    User.delete_all
    Person.delete_all
  end

  let(:db) { ActiveRecord::Base.connection_db_config.configuration_hash }

  def process_env(rails_env, variables)
    url = "postgresql://#{db[:username]}@#{db[:host]}:#{db[:port]}/#{db[:database]}"
    {
      "RAILS_ENV" => rails_env,
      "DATABASE_URL" => url,
      "DATABASE_PASSWORD" => db[:password].to_s,
      "GROWTH_LOG_DATABASE_PASSWORD" => db[:password].to_s,
      "SECRET_KEY_BASE_DUMMY" => "1",
      "GROWTH_LOG_DEMO_INSTANCE" => nil,
      "GROWTH_LOG_DEMO_PASSWORD_LUCIA" => nil,
      "GROWTH_LOG_DEMO_PASSWORD_MARTIN" => nil
    }.merge(variables)
  end

  def run_task(rails_env, variables)
    output, status = Open3.capture2e(process_env(rails_env, variables), "bin/rails", "growth_log:datos_demo", chdir: Rails.root.to_s)
    hidden = demo_passwords.values.reduce(output) { |text, password| text.gsub(password, "[OCULTA]") }
    [ output, status, hidden ]
  end

  {
    "development con el indicador" => [ "development", "growth-log-entrega-2" ],
    "test con el indicador" => [ "test", "growth-log-entrega-2" ],
    "production sin el indicador" => [ "production", nil ],
    "production con otro valor" => [ "production", "otra-instancia" ]
  }.each do |name, (rails_env, instance)|
    it "se niega en #{name} y no cambia la base" do
      create_user(email_address: "luis.lider@example.test")
      before = demo_snapshot

      output, status, hidden = run_task(rails_env, demo_variables(instance: instance))

      expect(status.exitstatus).to eq(1), hidden
      expect(output).to include("Solo se puede ejecutar en la instancia demo")
      demo_passwords.each_value { |password| expect(output).not_to include(password) }
      expect(demo_snapshot).to eq(before)
    end
  end

  it "en producción con el indicador crea el conjunto en una base dedicada vacía, sin mostrar contraseñas" do
    output, status, hidden = run_task("production", demo_variables)

    expect(status.exitstatus).to eq(0), hidden
    expect(output).to include("8 creados, 0 existentes")
    demo_passwords.each_value { |password| expect(output).not_to include(password) }
    expect(demo_counts).to eq([ 2, 1, 2, 3, 8 ])
  end

  it "en producción con el indicador se niega ante un registro ajeno" do
    create_user(email_address: "ana.admin@example.test", name: "Ana Admin", admin: true)
    before = demo_snapshot

    output, status, hidden = run_task("production", demo_variables)

    expect(status.exitstatus).to eq(1), hidden
    expect(output).to include("No se creó ni modificó ningún registro.")
    expect(demo_snapshot).to eq(before)
  end
end
