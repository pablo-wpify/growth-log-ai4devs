require "rails_helper"

# Conteo de entradas listas en «Personas» (GL-07; spec `people-browsing`,
# «Listado de personas asignadas»: 1.15 parcial y 3.3). Datos ficticios
# propios de cada prueba.
RSpec.describe "Conteo de entradas listas en «Personas»", type: :request do
  let!(:l1) { create_user(email_address: "luis.lider@example.test", name: "Luis Líder") }
  let!(:l2) { create_user(email_address: "lara.lider@example.test", name: "Lara Líder") }
  let!(:ada) { create_person(name: "Ada Ejemplo", role: "Desarrolladora", team: "Equipo Faro") }
  let!(:bruno) { create_person(name: "Bruno Ejemplo", role: "Analista", team: "Equipo Faro") }
  let!(:carla) { create_person(name: "Carla Ejemplo", role: "Diseñadora", team: "Equipo Brújula") }

  before do
    [ ada, bruno, carla ].each { |person| assign(l1, person) }
    assign(l2, ada)
  end

  def page = Nokogiri::HTML(response.body)
  def row_for(name) = page.css("main li").find { |li| li.at_css("[data-person-name]")&.text&.strip == name }

  def entry(person, author: l1, status: "ready")
    FeedbackEntry.create!(author:, person:, occurred_on: Date.new(2026, 11, 10), context: "Entrada de prueba",
                          status:, signal: "positive", dimension: "teamwork")
  end

  it "muestra «2 entradas listas», «1 entrada lista» y «0 entradas listas» después de «rol · equipo»" do
    2.times { entry(ada) }
    entry(ada, status: "draft")
    entry(bruno)

    sign_in_as(l1)
    get people_path

    { "Ada Ejemplo" => "2 entradas listas", "Bruno Ejemplo" => "1 entrada lista", "Carla Ejemplo" => "0 entradas listas" }.each do |name, count|
      row = row_for(name)
      parts = row.css("[data-person-name], .person-meta, [data-ready-count]").map { |part| part.text.strip }
      expect(parts).to eq([ name, row.at_css(".person-meta").text.strip, count ])
    end
  end

  it "no cuenta los borradores ni las entradas de otro líder de la misma persona" do
    entry(ada, status: "draft")
    entry(ada, author: l2)

    sign_in_as(l1)
    get people_path

    expect(row_for("Ada Ejemplo").at_css("[data-ready-count]").text.strip).to eq("0 entradas listas")
  end

  it "cuenta todas las personas con una sola consulta de entradas" do
    [ ada, bruno, carla ].each { |person| entry(person) }
    sign_in_as(l1)

    queries = []
    callback = ->(*, payload) { queries << payload[:sql] if payload[:sql].include?("feedback_entries") }
    ActiveSupport::Notifications.subscribed(callback, "sql.active_record") { get people_path }

    expect(response).to have_http_status(:ok)
    expect(queries.size).to eq(1)
  end
end
