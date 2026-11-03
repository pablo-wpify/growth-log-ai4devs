require "rails_helper"
require "rake"
require Rails.root.join("db/seeds/development").to_s

# Tarea growth_log:datos_ficticios (GL-08): salida sin contraseñas, negativa
# fuera de desarrollo y ningún otro camino que cree los datos.
RSpec.describe "Tarea de datos ficticios" do
  before(:all) do
    Rails.application.load_tasks unless Rake::Task.task_defined?("growth_log:datos_ficticios")
  end

  def run_command(env:, password_generator: -> { SecureRandom.base58(48) })
    output = StringIO.new
    service = DevelopmentSampleData.new(env: env, password_generator: password_generator)
    status = DevelopmentSampleDataCommand.new(service: service, output: output).call
    [ status, output.string ]
  end

  it "informa cada clave creada y no muestra ninguna contraseña" do
    generated = []
    status, output = run_command(env: development_env, password_generator: -> { SecureRandom.base58(48).tap { |p| generated << p } })

    expect(status).to eq(0)
    expect(output).to include("creado account:elena elena.boceto@ficticio.example.test")
    expect(output).to include("17 creados, 0 existentes")
    expect(generated.size).to eq(5)
    generated.each { |password| expect(output).not_to include(password) }
  end

  it "en la segunda ejecución informa que el conjunto ya existía" do
    run_command(env: development_env)
    status, output = run_command(env: development_env)

    expect(status).to eq(0)
    expect(output).to include("0 creados, 17 existentes")
  end

  it "ante un conflicto termina con error y lo explica" do
    create_user(email_address: "ines.muestra@ficticio.example.test", name: "Cuenta Ajena")

    status, output = run_command(env: development_env)

    expect(status).to eq(1)
    expect(output).to include("account:ines: ya existe una cuenta")
    expect(output).to include("No se creó ni modificó ningún registro.")
  end

  it "la tarea de Rake se niega en el entorno de test y no escribe" do
    output = StringIO.new
    original = $stdout
    $stdout = output
    begin
      expect { Rake::Task["growth_log:datos_ficticios"].execute }.to raise_error(SystemExit) { |e| expect(e.status).to eq(1) }
    ensure
      $stdout = original
    end

    expect(output.string).to include("Solo se puede ejecutar en desarrollo")
    expect(User.count + Person.count + Assignment.count + SampleDataRecord.count).to eq(0)
  end

  it "los seeds de desarrollo no crean datos ficticios" do
    DevelopmentSeeds.run

    expect(User.count + Person.count + Assignment.count + SampleDataRecord.count).to eq(0)
  end

  it "ni la configuración, ni los initializers, ni las migraciones, ni los seeds invocan la tarea" do
    files = Rails.root.glob("{config,db}/**/*.rb")

    invocation = /DevelopmentSampleData|Rake::Task\[\s*["']growth_log:datos_ficticios/

    expect(files.select { |f| File.read(f).match?(invocation) }).to be_empty
  end
end
