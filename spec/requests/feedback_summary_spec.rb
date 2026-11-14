require "rails_helper"

# Resumen por dimensión en la ficha (GL-07; spec `feedback-summary`: 4.1 con
# el ajuste de P-2, 3.3, 4.4 y 4.5). Datos ficticios propios de cada prueba.
RSpec.describe "Resumen por dimensión", type: :request do
  let!(:l1) { create_user(email_address: "luis.lider@example.test", name: "Luis Líder") }
  let!(:ada) { create_person(name: "Ada Ejemplo", role: "Desarrolladora", team: "Equipo Faro") }

  let(:not_a_score) { "Solo entradas listas. No es un puntaje: reúne evidencia para la conversación" }
  let(:empty_summary) { "Todavía no hay entradas listas para el resumen" }

  before { assign(l1, ada) }

  def page = Nokogiri::HTML(response.body)
  def section = page.at_css("[data-summary]")
  def header = section.css("thead th").map { |cell| cell.text.strip }
  def table_rows = section.css("tbody tr").map { |row| row.css("th, td").map { |cell| cell.text.strip } }

  def entry(status: "ready", signal: "positive", dimension: "teamwork", context: "Entrada de prueba")
    FeedbackEntry.create!(author: l1, person: ada, occurred_on: Date.new(2026, 11, 10), context:,
                          status:, signal:, dimension:)
  end

  def open_profile
    sign_in_as(l1)
    get person_path(ada)
  end

  it "titula la sección «Resumen por dimensión» y muestra las columnas de P-2" do
    entry
    open_profile

    expect(section.at_css("h2").text).to eq("Resumen por dimensión")
    expect(header).to eq([ "Dimensión", "Positivos", "A mejorar", "Neutrales", "Total" ])
  end

  it "muestra una fila por dimensión con datos, en el orden de P-1, con Total como suma" do
    2.times { entry(signal: "positive", dimension: "teamwork") }
    entry(signal: "neutral", dimension: "teamwork")
    entry(signal: "improvement", dimension: "delivery")
    open_profile

    expect(table_rows).to eq([
      [ "Entrega", "0", "1", "0", "1" ],
      [ "Trabajo en equipo", "2", "0", "1", "3" ]
    ])
  end

  it "no cuenta un borrador, aunque tenga señal y dimensión (3.3)" do
    entry(signal: "positive", dimension: "teamwork")
    entry(status: "draft", signal: "positive", dimension: "teamwork")
    entry(status: "draft", signal: "neutral", dimension: "initiative")
    open_profile

    expect(table_rows).to eq([ [ "Trabajo en equipo", "1", "0", "0", "1" ] ])
  end

  it "aclara que no es un puntaje (4.5)" do
    entry
    open_profile

    expect(section.text).to include(not_a_score)
  end

  it "con solo borradores, muestra el mensaje en lugar del resumen (4.4)" do
    entry(status: "draft")
    open_profile

    expect(section.at_css("table")).to be_nil
    expect(section.text).to include(empty_summary)
    expect(section.text).not_to include(not_a_score)
  end

  it "sin entradas, muestra el mensaje en lugar del resumen (4.4)" do
    open_profile

    expect(section.at_css("table")).to be_nil
    expect(section.text).to include(empty_summary)
  end
end
