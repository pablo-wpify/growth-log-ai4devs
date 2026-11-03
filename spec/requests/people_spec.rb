require "rails_helper"

# «Personas» y ficha (GL-05; 1.14, 1.16, 1.17, 1.19, 1.21 parcial, PP-2,
# PP-8). Datos ficticios propios de cada prueba: no usan la base de
# desarrollo ni la tarea de GL-08.
RSpec.describe "Personas", type: :request do
  let!(:l1) { create_user(email_address: "luis.lider@example.test", name: "Luis Líder") }
  let!(:l2) { create_user(email_address: "lara.lider@example.test", name: "Lara Líder") }
  let!(:l3) { create_user(email_address: "leo.lider@example.test", name: "Leo Líder") }
  let!(:admin) { create_user(email_address: "ana.admin@example.test", name: "Ana Admin", admin: true) }

  # Nombres creados fuera de orden para comprobar el orden del listado.
  let!(:bruno) { create_person(name: "Bruno Ejemplo", role: "Analista", team: "Equipo Faro") }
  let!(:ada) { create_person(name: "Ada Ejemplo", role: "Desarrolladora", team: "Equipo Faro") }
  let!(:ended) { create_person(name: "Elsa Terminada", role: "Diseñadora", team: "Equipo Sur") }
  let!(:inactive) { create_person(name: "Iris Inactiva", role: "Analista", team: "Equipo Sur", active: false) }
  let!(:unassigned) { create_person(name: "Ulises Sinlider", role: "Analista", team: "Equipo Sur") }
  let!(:no_role) { create_person(name: "Nora Sinrol", role: nil, team: nil) }

  before do
    assign(l1, ada)
    assign(l1, bruno)
    assign(l1, ended, started_at: 10.days.ago, ended_at: 2.days.ago)
    assign(l1, inactive)
    assign(l2, ada)
    assign(l2, no_role)
  end

  def listed_names
    Nokogiri::HTML(response.body).css("main li a").map { |a| a.at_css("[data-person-name]")&.text&.strip }
  end

  def missing_person_response
    get person_path(Person.maximum(:id).to_i + 1000)
    [ response.status, response.body ]
  end

  describe "listado" do
    it "muestra solo las personas activas con asignación activa, ordenadas por nombre, con rol y equipo" do
      sign_in_as(l1)
      get people_path

      expect(response).to have_http_status(:ok)
      expect(listed_names).to eq([ "Ada Ejemplo", "Bruno Ejemplo" ])
      expect(response.body).to include("Desarrolladora · Equipo Faro", "Analista · Equipo Faro")
      expect(response.body).not_to include("Elsa Terminada", "Iris Inactiva", "Ulises Sinlider", "Nora Sinrol")
    end

    it "responde igual en la página de inicio" do
      sign_in_as(l1)
      get root_path

      expect(response).to have_http_status(:ok)
      expect(listed_names).to eq([ "Ada Ejemplo", "Bruno Ejemplo" ])
    end

    it "enlaza cada persona con su ficha" do
      sign_in_as(l1)
      get people_path

      links = Nokogiri::HTML(response.body).css("main li a").map { |a| a["href"] }
      expect(links).to eq([ person_path(ada), person_path(bruno) ])
    end

    it "muestra a otro líder solo sus propias personas" do
      sign_in_as(l2)
      get people_path

      expect(listed_names).to eq([ "Ada Ejemplo", "Nora Sinrol" ])
      expect(response.body).not_to include("Bruno Ejemplo")
    end

    it "muestra el estado vacío a un líder sin asignaciones" do
      sign_in_as(l3)
      get people_path

      expect(response).to have_http_status(:ok)
      expect(listed_names).to be_empty
      expect(response.body).to include("Todavía no tenés personas asignadas.")
    end

    it "muestra el estado vacío a una administradora sin asignaciones" do
      sign_in_as(admin)
      get people_path

      expect(listed_names).to be_empty
      expect(response.body).to include("Todavía no tenés personas asignadas.")
    end

    it "muestra a una administradora asignada solo esa persona" do
      assign(admin, bruno)
      sign_in_as(admin)
      get people_path

      expect(listed_names).to eq([ "Bruno Ejemplo" ])
    end
  end

  describe "ficha" do
    it "muestra nombre, rol, equipo y el enlace a «Personas», sin los otros líderes" do
      sign_in_as(l1)
      get person_path(ada)

      expect(response).to have_http_status(:ok)
      page = Nokogiri::HTML(response.body)
      expect(page.at_css("main h1").text.strip).to eq("Ada Ejemplo")
      expect(page.at_css("main").text).to include("Desarrolladora · Equipo Faro")
      expect(page.at_css("main a[href='#{people_path}']").text).to include("Volver a Personas")
      expect(response.body).not_to include("Lara Líder")
    end

    it "la persona compartida no muestra al otro líder a ninguno de los dos" do
      sign_in_as(l2)
      get person_path(ada)

      expect(response).to have_http_status(:ok)
      expect(response.body).not_to include("Luis Líder")
    end

    it "indica cuando falta el rol o el equipo" do
      sign_in_as(l2)
      get person_path(no_role)

      main = Nokogiri::HTML(response.body).at_css("main").text
      expect(main).to include("Sin rol indicado", "Sin equipo indicado")
    end

    it "no muestra el estado, las fechas ni identificadores internos" do
      sign_in_as(l1)
      get person_path(ada)

      main = Nokogiri::HTML(response.body).at_css("main").text
      expect(main).not_to match(/activa|asignad[ao] desde|\b#{ada.id}\b/i)
    end
  end

  describe "persona fuera del alcance por URL directa" do
    {
      "sin asignación" => :unassigned,
      "inactiva" => :inactive,
      "con la asignación terminada" => :ended,
      "asignada solo a otro líder" => :no_role
    }.each do |label, person_key|
      it "#{label}: responde 404 igual que una inexistente, sin su nombre" do
        sign_in_as(l1)
        person = public_send(person_key)

        get person_path(person)
        out_of_scope = [ response.status, response.body ]

        expect(out_of_scope.first).to eq(404)
        expect(out_of_scope).to eq(missing_person_response)
        expect(out_of_scope.last).not_to include(person.name)
      end
    end

    it "una administradora sin asignación recibe 404 en cualquier ficha" do
      sign_in_as(admin)

      [ ada, bruno, unassigned ].each do |person|
        get person_path(person)
        expect([ response.status, response.body ]).to eq(missing_person_response)
        expect(response.body).not_to include(person.name)
      end
    end

    it "una administradora asignada a una persona recibe 404 en las demás" do
      assign(admin, bruno)
      sign_in_as(admin)

      get person_path(bruno)
      expect(response).to have_http_status(:ok)

      get person_path(ada)
      expect([ response.status, response.body ]).to eq(missing_person_response)
    end

    it "una persona inexistente responde 404" do
      sign_in_as(l1)

      expect(missing_person_response.first).to eq(404)
    end
  end
end
