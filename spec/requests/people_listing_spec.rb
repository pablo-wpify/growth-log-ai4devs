require "rails_helper"

# Listado «Personas» de GL-14 por petición (specs `people-browsing`,
# `feedback-capture` y `authorization`; P-41 a P-53). Datos ficticios propios
# de cada prueba. L1 es el líder que mira; L2 acompaña a las mismas personas
# y es el actor que no debe influir; A es una administradora asignada.
RSpec.describe "Listado «Personas» (GL-14)", type: :request do
  let!(:l1) { create_user(email_address: "luis.lider@example.test", name: "Luis Líder") }
  let!(:l2) { create_user(email_address: "lara.lider@example.test", name: "Lara Líder") }
  let!(:l3) { create_user(email_address: "leo.lider@example.test", name: "Leo Líder") }
  let!(:admin) { create_user(email_address: "ana.admin@example.test", name: "Ana Admin", admin: true) }

  let!(:ada) { create_person(name: "Ada Ejemplo", role: "Desarrolladora", team: "Equipo Faro") }
  let!(:bruno) { create_person(name: "Bruno Ejemplo", role: "Analista", team: "Equipo Norte") }
  let!(:carla) { create_person(name: "Carla Ejemplo", role: "Diseñadora", team: "Equipo Faro") }
  let!(:dario) { create_person(name: "Darío Ejemplo", role: "Analista", team: nil) }
  let!(:outsider) { create_person(name: "Ulises Sinlider", role: "Analista", team: "Equipo Brújula") }

  before do
    [ ada, bruno, carla, dario ].each { |person| assign(l1, person) }
    [ ada, bruno, carla ].each { |person| assign(l2, person) }
  end

  def page = Nokogiri::HTML(response.body)
  def rows = page.css("main li[data-person-row]")
  def row_for(name) = rows.find { |li| li.at_css("[data-person-name]")&.text&.strip == name }
  def count_for(name) = row_for(name).at_css("[data-entry-count]").text.strip
  def last_fact_for(name) = row_for(name).at_css("[data-last-fact-text]")&.text&.strip
  def first_entry_link(name) = row_for(name).at_css("a[data-first-entry]")

  def entry(person, author: l1, status: "ready", on: Date.new(2026, 5, 20))
    attributes = { author:, person:, occurred_on: on, context: "Entrada de prueba", status: }
    attributes.merge!(signal: "positive", dimension: "teamwork") if status == "ready"
    FeedbackEntry.create!(**attributes)
  end

  describe "conteos (P-41, P-46)" do
    it "muestra los cuatro casos después de «rol · equipo»" do
      2.times { entry(ada) }
      entry(ada, status: "draft")
      entry(bruno)
      entry(carla, status: "draft")

      sign_in_as(l1)
      get people_path

      expect(count_for("Ada Ejemplo")).to eq("2 entradas listas · 1 borrador")
      expect(count_for("Bruno Ejemplo")).to eq("1 entrada lista")
      expect(count_for("Carla Ejemplo")).to eq("Sin entradas listas · 1 borrador")
      expect(count_for("Darío Ejemplo")).to eq("Sin entradas todavía")
      parts = row_for("Ada Ejemplo").css("[data-person-name], .person-meta, [data-entry-count]").map { |part| part.text.strip }
      expect(parts).to eq([ "Ada Ejemplo", "Desarrolladora · Equipo Faro", "2 entradas listas · 1 borrador" ])
    end

    it "usa el singular y el plural" do
      entry(ada)
      entry(ada, status: "draft")
      3.times { entry(bruno) }
      2.times { entry(bruno, status: "draft") }

      sign_in_as(l1)
      get people_path

      expect(count_for("Ada Ejemplo")).to eq("1 entrada lista · 1 borrador")
      expect(count_for("Bruno Ejemplo")).to eq("3 entradas listas · 2 borradores")
    end
  end

  describe "«Último hecho» (P-42)" do
    it "muestra la entrada lista más reciente y no la fecha posterior de un borrador" do
      entry(ada, on: Date.new(2026, 3, 12))
      entry(ada, on: Date.new(2026, 5, 20))
      entry(ada, status: "draft", on: Date.new(2026, 6, 8))
      entry(bruno, status: "draft", on: Date.new(2026, 6, 8))

      sign_in_as(l1)
      get people_path

      expect(last_fact_for("Ada Ejemplo")).to eq("Último hecho: 20/05/2026")
      expect(row_for("Ada Ejemplo")["data-last-fact"]).to eq("2026-05-20")
      expect(last_fact_for("Bruno Ejemplo")).to be_nil
      expect(row_for("Bruno Ejemplo")["data-last-fact"]).to eq("")
      expect(last_fact_for("Darío Ejemplo")).to be_nil
    end
  end

  describe "otro líder de la misma persona (1.15 parcial, PP-2)" do
    it "su entrada lista posterior y su borrador no cambian conteos, fecha ni orden" do
      entry(ada, on: Date.new(2026, 5, 20))
      entry(bruno, on: Date.new(2026, 4, 1))
      entry(bruno, author: l2, on: Date.new(2026, 6, 10))
      entry(bruno, author: l2, status: "draft", on: Date.new(2026, 6, 11))
      entry(carla, author: l2)
      entry(carla, author: l2, status: "draft")

      sign_in_as(l1)
      get people_path

      expect(count_for("Bruno Ejemplo")).to eq("1 entrada lista")
      expect(last_fact_for("Bruno Ejemplo")).to eq("Último hecho: 01/04/2026")
      expect(row_for("Bruno Ejemplo")["data-last-fact"]).to eq("2026-04-01")
      expect(count_for("Carla Ejemplo")).to eq("Sin entradas todavía")
      expect(row_for("Carla Ejemplo")["data-last-fact"]).to eq("")
      expect(first_entry_link("Carla Ejemplo")).not_to be_nil
    end

    it "con una entrada lista propia, sigue mostrando solo la suya" do
      entry(ada)
      2.times { entry(ada, author: l2) }
      entry(ada, author: l2, status: "draft")

      sign_in_as(l1)
      get people_path

      expect(count_for("Ada Ejemplo")).to eq("1 entrada lista")
    end
  end

  describe "administradora asignada sin entradas (PP-8)" do
    it "ve la persona sin entradas, sin fecha y con «Registrar la primera», aunque otros tengan entradas" do
      assign(admin, ada)
      entry(ada)
      entry(ada, author: l2, status: "draft")

      sign_in_as(admin)
      get people_path

      expect(rows.size).to eq(1)
      expect(count_for("Ada Ejemplo")).to eq("Sin entradas todavía")
      expect(last_fact_for("Ada Ejemplo")).to be_nil
      expect(first_entry_link("Ada Ejemplo")).not_to be_nil
    end
  end

  describe "«Registrar la primera» (P-45, P-52)" do
    it "aparece solo en las personas sin entradas de la cuenta, fuera del enlace de la fila" do
      entry(ada)
      entry(bruno, status: "draft")

      sign_in_as(l1)
      get people_path

      expect(first_entry_link("Ada Ejemplo")).to be_nil
      expect(first_entry_link("Bruno Ejemplo")).to be_nil
      link = first_entry_link("Carla Ejemplo")
      expect(link.text.strip).to eq("Registrar la primera")
      expect(link["href"]).to eq(new_person_feedback_entry_path(carla))
      expect(link["aria-label"]).to eq("Registrar la primera entrada sobre Carla Ejemplo")
      expect(link.ancestors("a")).to be_empty
      expect(row_for("Carla Ejemplo").at_css("a[data-person-link]").css("a, button")).to be_empty
    end

    it "lleva a la captura, que guarda un borrador del líder y vuelve a la ficha" do
      sign_in_as(l1)
      get new_person_feedback_entry_path(dario)
      expect(response).to have_http_status(:ok)
      expect(Nokogiri::HTML(response.body).at_css("main a[href='#{person_path(dario)}']")).not_to be_nil

      expect {
        post person_feedback_entries_path(dario), params: { feedback_entry: { context: "Primera entrada de Luis" } }
      }.to change { FeedbackEntry.where(author: l1, person: dario, status: "draft").count }.by(1)
      expect(response).to redirect_to(person_path(dario))
    end

    it "por URL directa, con una persona fuera del alcance, responde 404 en new y en create sin crear entradas" do
      sign_in_as(l1)

      get new_person_feedback_entry_path(outsider)
      expect(response).to have_http_status(:not_found)

      expect {
        post person_feedback_entries_path(outsider), params: { feedback_entry: { context: "Intento" } }
      }.not_to change(FeedbackEntry, :count)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "total y aviso de privacidad (P-53)" do
    let(:privacy_note) { "Ves solo a quienes tenés asignados y las entradas que podés ver" }

    it "muestran una sola vez el total de personas asignadas y el aviso" do
      sign_in_as(l1)
      get people_path

      expect(page.css("[data-people-total]").map { |el| el.text.strip }).to eq([ "4 personas que acompañás" ])
      expect(response.body.scan(privacy_note).size).to eq(1)
    end

    it "usan el singular con una sola persona" do
      assign(l3, ada)
      sign_in_as(l3)
      get people_path

      expect(page.at_css("[data-people-total]").text.strip).to eq("1 persona que acompañás")
    end

    it "el estado vacío los reemplaza, sin controles" do
      sign_in_as(l3)
      get people_path

      expect(response.body).to include("Todavía no tenés personas asignadas.")
      expect(page.css("[data-people-total]")).to be_empty
      expect(response.body).not_to include(privacy_note)
      expect(page.css("main input, main select")).to be_empty
    end
  end

  describe "búsqueda, filtro y orden (P-49 a P-51)" do
    before do
      sign_in_as(l1)
      get people_path
    end

    it "se sirven ocultos, sin formulario ni estado en la URL, para que el navegador los muestre" do
      controls = page.at_css("[data-people-list-target=controls]")
      expect(controls).not_to be_nil
      expect(controls["hidden"]).not_to be_nil
      expect(controls.ancestors("form")).to be_empty
      expect(page.css("form").map { |form| form["action"] }).to eq([ session_path ])
    end

    it "el filtro ofrece solo «Todos», los equipos de las personas asignadas y «Sin equipo indicado»" do
      options = page.css("select[data-people-list-target=team] option").map { |option| option.text.strip }
      expect(options).to eq([ "Todos", "Equipo Faro", "Equipo Norte", "Sin equipo indicado" ])
    end

    it "el orden ofrece «Nombre», el predeterminado, y «Hechos más recientes»" do
      options = page.css("select[data-people-list-target=order] option")
      expect(options.map { |option| option.text.strip }).to eq([ "Nombre", "Hechos más recientes" ])
      expect(options.first["selected"]).not_to be_nil
    end

    it "cada fila lleva el nombre normalizado y el equipo, y el listado sale por nombre" do
      expect(rows.map { |row| row.at_css("[data-person-name]").text.strip })
        .to eq([ "Ada Ejemplo", "Bruno Ejemplo", "Carla Ejemplo", "Darío Ejemplo" ])
      expect(row_for("Darío Ejemplo")["data-search-name"]).to eq("dario ejemplo")
      expect(row_for("Darío Ejemplo")["data-team"]).to eq("")
      expect(row_for("Ada Ejemplo")["data-team"]).to eq("Equipo Faro")
    end
  end
end
