require "rails_helper"

RSpec.describe "Inicio y cierre de sesión", type: :request do
  let(:generic_failure) { "Correo o contraseña incorrectos." }
  let!(:user) { create_user(email_address: "luis.lider@example.test", name: "Luis Líder") }

  def alert_text
    Nokogiri::HTML(response.body).at_css("[role=alert]")&.text&.strip
  end

  def session_cookie_header
    Array(response.headers["Set-Cookie"]).flat_map { |h| h.split("\n") }.find { |c| c.start_with?("session_id=") }
  end

  it "muestra el formulario sin registro ni recuperación de contraseña" do
    get new_session_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Iniciar sesión")
    expect(response.body).not_to match(/olvid|registr|crear cuenta/i)
  end

  describe "credenciales válidas" do
    it "crea una sesión y lleva a la página de inicio" do
      sign_in_as(user)

      expect(response).to have_http_status(:see_other)
      expect(response).to redirect_to(root_url)
      expect(Session.where(user: user).count).to eq(1)

      follow_redirect!
      expect(response.body).to include("Sesión iniciada como Luis Líder")
    end

    it "acepta el correo con mayúsculas y espacios alrededor" do
      post session_path, params: { email_address: "  LUIS.Lider@Example.TEST ", password: user.password }

      expect(response).to redirect_to(root_url)
      expect(Session.count).to eq(1)
    end

    it "lleva a la página pedida antes de iniciar sesión" do
      get root_path(origen: "prueba")
      expect(response).to redirect_to(new_session_path)

      sign_in_as(user)

      expect(response).to redirect_to(root_url(origen: "prueba"))
    end

    it "recuerda también la página pedida con HEAD, pero no con un envío" do
      head root_path(origen: "head")
      sign_in_as(user)
      expect(response).to redirect_to(root_url(origen: "head"))

      delete session_path
      delete session_path # sin sesión: redirige sin recordar la URL
      sign_in_as(user)
      expect(response).to redirect_to(root_url)
    end
  end

  describe "credenciales inválidas" do
    let(:responses) { {} }

    def attempt(label, email, password)
      post session_path, params: { email_address: email, password: password }
      responses[label] = { status: response.status, alert: alert_text, sessions: Session.count }
    end

    it "responde igual ante contraseña incorrecta, correo desconocido y cuenta desactivada" do
      deactivated = create_user(email_address: "eva.inactiva@example.test", name: "Eva Inactiva", deactivated_at: Time.current)

      attempt(:contraseña_incorrecta, user.email_address, generated_password)
      attempt(:correo_desconocido, "nadie@example.test", generated_password)
      attempt(:cuenta_desactivada, deactivated.email_address, deactivated.password)

      expect(responses.values.map { |r| r[:status] }.uniq).to eq([ 422 ])
      expect(responses.values.map { |r| r[:alert] }.uniq).to eq([ generic_failure ])
      expect(responses.values.map { |r| r[:sessions] }.uniq).to eq([ 0 ])
    end
  end

  describe "cierre de sesión" do
    it "elimina la sesión del servidor y la cookie deja de servir aunque se reenvíe" do
      sign_in_as(user)
      retained_cookie = cookies[:session_id]

      delete session_path

      expect(response).to have_http_status(:see_other)
      expect(response).to redirect_to(new_session_path)
      expect(Session.count).to eq(0)

      cookies[:session_id] = retained_cookie
      get root_path
      expect(response).to redirect_to(new_session_path)
    end

    it "exige sesión" do
      delete session_path

      expect(response).to redirect_to(new_session_path)
    end
  end

  it "descarta la sesión anónima previa al iniciar sesión" do
    get root_path # sin sesión: crea una sesión anónima con la URL de retorno
    anonymous_id = session.id.to_s
    expect(anonymous_id).to be_present

    sign_in_as(user)

    expect(session.id.to_s).to be_present
    expect(session.id.to_s).not_to eq(anonymous_id)
  end

  describe "atributos de la cookie de sesión" do
    it "por HTTPS es HttpOnly, SameSite=Lax, Secure y vence a las 12 horas" do
      now = Time.zone.local(2026, 11, 2, 9, 0, 0)
      https!

      travel_to(now) { sign_in_as(user) }

      cookie = session_cookie_header
      expect(cookie).to match(/;\s*httponly/i)
      expect(cookie).to match(/;\s*samesite=lax/i)
      expect(cookie).to match(/;\s*secure/i)
      expires = Time.httpdate(cookie[/expires=([^;]+)/i, 1])
      expect(expires).to eq(now + 12.hours)
    end

    it "por HTTP no se marca Secure" do
      sign_in_as(user)

      expect(session_cookie_header).not_to match(/;\s*secure/i)
    end
  end
end
