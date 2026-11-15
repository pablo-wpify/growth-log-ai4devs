require "rails_helper"

# Presentación de la página de inicio de sesión (GL-11, capability
# sign-in-presentation): estructura del formulario y de los avisos. El
# comportamiento sigue siendo el de la spec `authentication`; estas pruebas
# solo miran el marcado.
RSpec.describe "Presentación de la página de inicio de sesión", type: :request do
  let!(:user) { create_user(email_address: "luis.lider@example.test", name: "Luis Líder") }

  def page_html = Nokogiri::HTML(response.body)
  def form = page_html.at_css("main form[action='#{session_path}']")

  def attempt(email:, password:, ip: "203.0.113.10")
    post session_path, params: { email_address: email, password: password }, env: { "REMOTE_ADDR" => ip }
  end

  def expect_alert_before_form(text)
    alert = page_html.at_css("main [role=alert]")
    expect(alert).to be_present
    expect(alert.text.strip).to eq(text)
    expect(alert["class"].to_s.split).to include("error-summary")
    following = alert.xpath("following::form")
    expect(following.map { |f| f["action"] }).to include(session_path)
  end

  def expect_no_field_marked_invalid
    expect(page_html.css("[aria-invalid]")).to be_empty
    expect(form.css("input[aria-describedby]")).to be_empty
    expect(form.css(".field-error")).to be_empty
  end

  it "agrupa cada etiqueta con su campo, en un formulario con clase propia" do
    get new_session_path

    expect(form["class"].to_s.split).to include("sign-in-form")
    groups = form.css(".field")
    expect(groups.size).to eq(2)

    [ [ groups[0], "Correo", "email_address" ], [ groups[1], "Contraseña", "password" ] ].each do |group, text, id|
      label, input = group.element_children.to_a
      expect(label.name).to eq("label")
      expect(label.text.strip).to eq(text)
      expect(input.name).to eq("input")
      expect(label["for"]).to eq(id)
      expect(input["id"]).to eq(id)
    end
  end

  it "pone el botón «Iniciar sesión» después del campo de contraseña" do
    get new_session_path

    sign_in_form = form
    children = sign_in_form.element_children.reject { |el| el.name == "input" && el["type"] == "hidden" }
    expect(children.last.name).to eq("input")
    expect(children.last["type"]).to eq("submit")
    expect(children.last["value"]).to eq("Iniciar sesión")
    password_group = sign_in_form.at_css("#password").parent
    expect(password_group["class"].to_s.split).to include("field")
    expect(children.index(password_group)).to eq(children.size - 2)
  end

  it "conserva los nombres y los atributos de los campos" do
    get new_session_path

    email = form.at_css("#email_address")
    password = form.at_css("#password")
    expect(email.to_h.slice("type", "name", "required", "autofocus", "autocomplete"))
      .to eq("type" => "email", "name" => "email_address", "required" => "required", "autofocus" => "autofocus", "autocomplete" => "username")
    expect(password.to_h.slice("type", "name", "required", "autocomplete", "maxlength"))
      .to eq("type" => "password", "name" => "password", "required" => "required", "autocomplete" => "current-password", "maxlength" => "72")
  end

  it "no usa estilos en línea ni muestra la cabecera" do
    get new_session_path

    expect(page_html.css("main [style]")).to be_empty
    expect(page_html.at_css("header")).to be_nil
    expect(page_html.at_css("title").text).to eq("Iniciar sesión · Growth Log")
  end

  it "muestra el aviso genérico de fallo antes del formulario, sin marcar un campo" do
    sign_in_as(user, password: generated_password)

    expect(response).to have_http_status(:unprocessable_content)
    expect_alert_before_form("Correo o contraseña incorrectos.")
    expect_no_field_marked_invalid
    expect(form.at_css("#email_address")["value"]).to eq(user.email_address)
  end

  it "muestra el aviso de demasiados intentos en el mismo lugar y con la misma presentación" do
    travel_to(Time.zone.local(2026, 11, 2, 9, 0, 0)) do
      10.times { |i| attempt(email: "desconocido#{i}@example.test", password: generated_password) }
      attempt(email: user.email_address, password: user.password)
    end

    expect(response).to have_http_status(:too_many_requests)
    expect_alert_before_form("Demasiados intentos. Probá de nuevo en unos minutos.")
    expect_no_field_marked_invalid
  end
end
