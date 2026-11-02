require "rails_helper"

RSpec.describe "Protección CSRF", type: :request do
  let!(:user) { create_user }

  around do |example|
    original = ActionController::Base.allow_forgery_protection
    ActionController::Base.allow_forgery_protection = true
    example.run
  ensure
    ActionController::Base.allow_forgery_protection = original
  end

  def form_token(path)
    get path
    Nokogiri::HTML(response.body).at_css("input[name=authenticity_token]")&.[]("value")
  end

  it "el formulario de inicio de sesión incluye el token" do
    expect(form_token(new_session_path)).to be_present
  end

  it "rechaza el inicio de sesión sin token y no crea sesión" do
    post session_path, params: { email_address: user.email_address, password: user.password }

    expect(response).to have_http_status(:unprocessable_content)
    expect(Session.count).to eq(0)
  end

  it "acepta el inicio de sesión con token" do
    token = form_token(new_session_path)

    post session_path, params: { email_address: user.email_address, password: user.password, authenticity_token: token }

    expect(response).to redirect_to(root_url)
    expect(Session.count).to eq(1)
  end

  it "rechaza el cierre de sesión sin token y la sesión sigue existiendo" do
    token = form_token(new_session_path)
    post session_path, params: { email_address: user.email_address, password: user.password, authenticity_token: token }
    expect(Session.count).to eq(1)

    delete session_path

    expect(response).to have_http_status(:unprocessable_content)
    expect(Session.count).to eq(1)
  end
end
