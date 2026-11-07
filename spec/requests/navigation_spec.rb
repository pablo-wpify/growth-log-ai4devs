require "rails_helper"

# Navegación con sesión (GL-05, P-15): la página de inicio es «Personas» y
# toda página con sesión lleva la cabecera. Solo lectura: el único
# formulario es «Cerrar sesión».
RSpec.describe "Navegación con sesión", type: :request do
  let!(:leader) { create_user(email_address: "luis.lider@example.test", name: "Luis Líder") }
  let!(:ada) { create_person(name: "Ada Ejemplo", role: "Desarrolladora", team: "Equipo Faro") }

  before { assign(leader, ada) }

  def page
    Nokogiri::HTML(response.body)
  end

  def header
    page.at_css("header nav[aria-label='Principal']")
  end

  it "tras iniciar sesión se llega al listado «Personas» con la cabecera" do
    sign_in_as(leader)
    follow_redirect!

    expect(response).to have_http_status(:ok)
    expect(page.at_css("main h1").text.strip).to eq("Personas")
    expect(page.at_css("title").text).to eq("Personas · Growth Log")
    expect(header.text).to include("Growth Log", "Personas", "Sesión iniciada como Luis Líder")
    expect(header.at_css("form[action='#{session_path}'] button").text.strip).to eq("Cerrar sesión")
  end

  it "la cabecera marca «Personas» como actual en el listado y en la ficha" do
    sign_in_as(leader)

    [ people_path, person_path(ada) ].each do |path|
      get path
      current = header.at_css("a[aria-current='page']")
      expect(current&.text&.strip).to eq("Personas"), "sin «Personas» actual en #{path}"
      expect(current["href"]).to eq(people_path)
    end
  end

  it "la ficha titula la página con el nombre de la persona" do
    sign_in_as(leader)
    get person_path(ada)

    expect(page.at_css("title").text).to eq("Ada Ejemplo · Growth Log")
  end

  it "el inicio de sesión no muestra la cabecera" do
    get new_session_path

    expect(response).to have_http_status(:ok)
    expect(page.at_css("header")).to be_nil
    expect(response.body).not_to include("Cerrar sesión")
  end

  it "el cierre de sesión desde la cabecera lleva al inicio de sesión" do
    sign_in_as(leader)
    get people_path

    delete header.at_css("form")["action"]

    expect(response).to redirect_to(new_session_path)
    get people_path
    expect(response).to redirect_to(new_session_path)
  end

  it "el único formulario es «Cerrar sesión» y no hay funciones inexistentes" do
    sign_in_as(leader)

    [ people_path, person_path(ada) ].each do |path|
      get path
      forms = page.css("form")
      expect(forms.size).to eq(1), "#{path} tiene #{forms.size} formularios"
      expect(forms.first["action"]).to eq(session_path)
      expect(page.text).not_to match(/feedback|captura r[aá]pida|administr|crear|editar|asignar|nueva persona/i)
    end
  end
end
