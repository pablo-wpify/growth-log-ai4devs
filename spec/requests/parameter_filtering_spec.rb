require "rails_helper"

RSpec.describe "Filtrado de credenciales en los logs", type: :request do
  around do |example|
    original = ActionController::Base.logger
    @log = StringIO.new
    ActionController::Base.logger = ActiveSupport::Logger.new(@log)
    example.run
  ensure
    ActionController::Base.logger = original
  end

  it "no escribe la contraseña ni el correo de un intento de inicio de sesión" do
    password = generated_password

    post session_path, params: { email_address: "luis.lider@example.test", password: password }

    expect(@log.string).to include("[FILTERED]")
    expect(@log.string).not_to include(password)
    expect(@log.string).not_to include("luis.lider@example.test")
  end
end
