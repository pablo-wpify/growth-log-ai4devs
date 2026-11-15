require "rails_helper"
require "rake"
require Rails.root.join("db/seeds/development").to_s

# Tarea growth_log:datos_demo (GL-10): salida sin contraseñas, negativa fuera
# de la instancia demo y ningún otro camino que cree los datos demo.
RSpec.describe "Tarea de datos demo" do
  before(:all) do
    Rails.application.load_tasks unless Rake::Task.task_defined?("growth_log:datos_demo")
  end

  def run_command(env: production_env, variables: demo_variables)
    output = StringIO.new
    status = DemoDataCommand.new(service: DemoData.new(env: env, variables: variables), output: output).call
    [ status, output.string ]
  end

  it "informa cada clave creada y no muestra contraseñas ni hashes" do
    status, output = run_command

    expect(status).to eq(0)
    expect(output).to include("creado demo:account:lucia lucia.demo@ficticio.example.test")
    expect(output).to include("8 creados, 0 existentes")
    demo_passwords.each_value { |password| expect(output).not_to include(password) }
    User.find_each { |user| expect(output).not_to include(user.password_digest) }
  end

  it "en la segunda ejecución informa que el conjunto ya existía" do
    run_command
    status, output = run_command(variables: demo_variables(passwords: {}))

    expect(status).to eq(0)
    expect(output).to include("0 creados, 8 existentes")
  end

  it "ante una contraseña inválida termina con error sin mostrarla" do
    short = SecureRandom.alphanumeric(User::PASSWORD_MIN_LENGTH - 1)
    status, output = run_command(variables: demo_variables(passwords: demo_passwords.merge("GROWTH_LOG_DEMO_PASSWORD_MARTIN" => short)))

    expect(status).to eq(1)
    expect(output).to include("GROWTH_LOG_DEMO_PASSWORD_MARTIN")
    expect(output).to include("No se creó ni modificó ningún registro.")
    expect(output).not_to include(short)
  end

  it "ante un registro ajeno termina con error y lo explica" do
    create_user(email_address: "ana.admin@example.test", name: "Ana Admin", admin: true)
    status, output = run_command

    expect(status).to eq(1)
    expect(output).to include("No se creó ni modificó ningún registro.")
  end

  it "fuera de la instancia demo termina con error" do
    status, output = run_command(variables: demo_variables(instance: nil))

    expect(status).to eq(1)
    expect(output).to include("Solo se puede ejecutar en la instancia demo")
  end

  it "la tarea de Rake se niega en el entorno de test y no escribe" do
    output = StringIO.new
    original = $stdout
    $stdout = output
    begin
      expect { Rake::Task["growth_log:datos_demo"].execute }.to raise_error(SystemExit) { |e| expect(e.status).to eq(1) }
    ensure
      $stdout = original
    end

    expect(output.string).to include("Solo se puede ejecutar en la instancia demo")
    expect(demo_counts).to eq([ 0, 0, 0, 0, 0 ])
  end

  it "los seeds no crean datos demo" do
    DevelopmentSeeds.run
    load Rails.root.join("db/seeds.rb")

    expect(demo_counts).to eq([ 0, 0, 0, 0, 0 ])
  end

  it "ni la configuración, ni los initializers, ni las migraciones, ni los seeds, ni Puma invocan la tarea" do
    files = Rails.root.glob("{config,db}/**/*.rb") + [ Rails.root.join("config.ru") ]

    invocation = /DemoData\b|DemoDataCommand|growth_log:datos_demo/

    expect(files.select { |f| File.read(f).match?(invocation) }).to be_empty
  end
end
