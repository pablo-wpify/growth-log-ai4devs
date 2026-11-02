# Ayudas de prueba para GL-02. Solo datos ficticios: correos en example.test
# y contraseñas generadas en cada prueba, nunca literales reutilizables.
module AuthenticationHelpers
  def generated_password(length: 24)
    SecureRandom.alphanumeric(length)
  end

  def create_user(email_address: "luis.lider@example.test", name: "Luis Líder", password: generated_password, **attributes)
    User.create!(email_address: email_address, name: name, password: password, **attributes)
  end

  def sign_in_as(user, password: user.password, headers: {})
    post session_path, params: { email_address: user.email_address, password: password }, headers: headers
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers
  config.include ActiveSupport::Testing::TimeHelpers
end
