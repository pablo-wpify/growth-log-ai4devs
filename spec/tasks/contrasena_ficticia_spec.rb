require "rails_helper"
require "rake"

# Tarea growth_log:contrasena_ficticia (GL-08, P-14). Las contraseñas se
# generan en cada ejemplo y nunca se imprimen.
RSpec.describe "Contraseña de una cuenta ficticia", type: :request do
  before(:all) do
    Rails.application.load_tasks unless Rake::Task.task_defined?("growth_log:contrasena_ficticia")
  end

  before { run_sample_data }

  let(:elena) { sample_user("account:elena") }
  let(:delia) { sample_user("account:delia") }

  def set_password(email:, input:, env: development_env, vars: {})
    output = StringIO.new
    status = SampleAccountPasswordCommand.new(
      input: StringIO.new(input), output: output, env: { "EMAIL" => email }.merge(vars), rails_env: env
    ).call
    [ status, output.string ]
  end

  it "establece la contraseña de una cuenta activa del conjunto sin mostrarla" do
    password = generated_password

    status, output = set_password(email: elena.email_address, input: "#{password}\n#{password}\n")

    expect(status).to eq(0)
    expect(output).to include("Contraseña actualizada para elena.boceto@ficticio.example.test")
    expect(output).not_to include(password)
    expect(User.authenticate_by(email_address: elena.email_address, password: password)).to eq(elena)
    expect(elena.reload).to have_attributes(admin: false, name: "Elena Boceto")
    expect(elena).to be_active
  end

  it "elimina las sesiones existentes: una cookie anterior deja de valer" do
    first = generated_password
    set_password(email: elena.email_address, input: "#{first}\n#{first}\n")
    sign_in_as(elena, password: first)
    get root_path
    expect(response).to have_http_status(:ok)

    second = generated_password
    set_password(email: elena.email_address, input: "#{second}\n#{second}\n")

    expect(elena.sessions.count).to eq(0)
    get root_path
    expect(response).to redirect_to(new_session_path)
  end

  it "en la cuenta desactivada cambia la contraseña y elimina sesiones, pero sigue desactivada y no inicia sesión" do
    delia.sessions.create!(ip_address: "198.51.100.7", user_agent: "prueba")
    digest = delia.password_digest
    password = generated_password

    status, _output = set_password(email: delia.email_address, input: "#{password}\n#{password}\n")

    expect(status).to eq(0)
    expect(delia.reload.password_digest).not_to eq(digest)
    expect(delia.sessions.count).to eq(0)
    expect(delia).not_to be_active

    post session_path, params: { email_address: delia.email_address, password: password }
    expect(response).to have_http_status(:unprocessable_content)
    expect(delia.sessions.count).to eq(0)
  end

  it "no cambia contraseña ni sesiones si las contraseñas no coinciden o son cortas" do
    elena.sessions.create!(ip_address: "198.51.100.8", user_agent: "prueba")
    digest = elena.password_digest

    mismatch_status, mismatch_output = set_password(email: elena.email_address, input: "#{generated_password}\n#{generated_password}\n")
    short = "a" * 14
    short_status, short_output = set_password(email: elena.email_address, input: "#{short}\n#{short}\n")

    expect([ mismatch_status, short_status ]).to eq([ 1, 1 ])
    expect(mismatch_output).to include("Las contraseñas no coinciden.")
    expect(short_output).to match(/15/)
    expect(short_output).not_to include(short)
    expect(elena.reload.password_digest).to eq(digest)
    expect(elena.sessions.count).to eq(1)
  end

  it "se niega para una cuenta que no forma parte del conjunto, también una administradora" do
    foreign = create_user(email_address: "luis.lider@example.test")
    admin = create_user(email_address: "ana.admin@example.test", name: "Ana Admin", admin: true)

    [ foreign, admin ].each do |user|
      digest = user.password_digest
      password = generated_password
      status, output = set_password(email: user.email_address, input: "#{password}\n#{password}\n")

      expect(status).to eq(1)
      expect(output).to include("No es una cuenta del conjunto ficticio.")
      expect(user.reload.password_digest).to eq(digest)
    end
  end

  it "se niega para un correo desconocido" do
    password = generated_password
    status, output = set_password(email: "nadie@ficticio.example.test", input: "#{password}\n#{password}\n")

    expect(status).to eq(1)
    expect(output).to include("No es una cuenta del conjunto ficticio.")
  end

  it "no lee la contraseña de variables de entorno" do
    digest = elena.password_digest
    password = generated_password

    status, _output = set_password(email: elena.email_address, input: "", vars: { "PASSWORD" => password, "CONTRASENA" => password })

    expect(status).to eq(1)
    expect(elena.reload.password_digest).to eq(digest)
  end

  it "fuera de desarrollo se niega sin cambiar la cuenta" do
    digest = elena.password_digest
    password = generated_password

    status, output = set_password(email: elena.email_address, input: "#{password}\n#{password}\n", env: ActiveSupport::EnvironmentInquirer.new("test"))

    expect(status).to eq(1)
    expect(output).to include("Solo se puede ejecutar en desarrollo")
    expect(elena.reload.password_digest).to eq(digest)
  end

  it "la tarea de Rake está declarada y se niega en el entorno de test" do
    original = $stdout
    $stdout = StringIO.new
    begin
      expect { Rake::Task["growth_log:contrasena_ficticia"].execute }.to raise_error(SystemExit) { |e| expect(e.status).to eq(1) }
    ensure
      $stdout = original
    end
  end
end
