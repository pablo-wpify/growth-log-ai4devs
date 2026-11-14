require "rails_helper"

# Privacidad de las lecturas agregadas de GL-07: resumen, cronología y conteo
# (spec `authorization`, «Lecturas agregadas con el alcance de entradas»;
# 4.11, 4.12 y 1.15 parciales, PP-2, PP-4, PP-6, PP-8). Matriz del diseño:
# L1 y L2 acompañan a P; A es administradora asignada a P sin entradas; Q es
# otra persona de L1 sin entradas. Datos ficticios propios de cada prueba.
RSpec.describe "Lecturas agregadas con el alcance de entradas", type: :request do
  let!(:l1) { create_user(email_address: "luis.lider@example.test", name: "Luis Líder") }
  let!(:l2) { create_user(email_address: "lara.lider@example.test", name: "Lara Líder") }
  let!(:admin) { create_user(email_address: "ana.admin@example.test", name: "Ana Admin", admin: true) }
  let!(:p) { create_person(name: "Ada Ejemplo", role: "Desarrolladora", team: "Equipo Faro") }
  let!(:q) { create_person(name: "Bruno Ejemplo", role: "Analista", team: "Equipo Faro") }

  let(:ready_text) { "Lista-privada-de-Luis-#{SecureRandom.hex(4)}" }
  let(:draft_text) { "Borrador-privado-de-Luis-#{SecureRandom.hex(4)}" }

  before do
    assign(l1, p)
    assign(l1, q)
    assign(l2, p)
    assign(admin, p)
    FeedbackEntry.create!(author: l1, person: p, occurred_on: Date.new(2026, 11, 10), context: ready_text,
                          status: "ready", dimension: "teamwork", signal: "positive")
    FeedbackEntry.create!(author: l1, person: p, occurred_on: Date.new(2026, 11, 11), context: draft_text,
                          dimension: "delivery", signal: "improvement")
  end

  def page = Nokogiri::HTML(response.body)
  def summary_rows = page.css("[data-summary] tbody tr")
  def summary_dimensions = summary_rows.map { |row| row.at_css("th").text.strip }
  def timeline_rows = page.css("[data-timeline] li")
  def count_for(name)
    row = page.css("main li").find { |li| li.at_css("[data-person-name]")&.text&.strip == name }
    row&.at_css("[data-ready-count]")&.text&.strip
  end

  describe "otro líder de la misma persona (L2)" do
    before { sign_in_as(l2) }

    it "su resumen y su cronología no incluyen las entradas de L1, y la respuesta no contiene su texto" do
      get person_path(p)

      expect(response).to have_http_status(:ok)
      expect(summary_rows).to be_empty
      expect(timeline_rows).to be_empty
      expect(response.body).not_to include(ready_text)
      expect(response.body).not_to include(draft_text)
    end

    it "su conteo de P no incluye la entrada lista de L1" do
      get people_path

      expect(count_for("Ada Ejemplo")).to eq("0 entradas listas")
      expect(response.body).not_to include(ready_text)
    end

    it "con una entrada lista propia, ve solo la suya en el resumen (4.12)" do
      FeedbackEntry.create!(author: l2, person: p, occurred_on: Date.new(2026, 11, 9), context: "Entrada de Lara",
                            status: "ready", dimension: "communication", signal: "neutral")

      get person_path(p)

      expect(summary_dimensions).to eq([ "Comunicación" ])
      expect(timeline_rows.size).to eq(1)
      expect(response.body).not_to include(ready_text)
    end
  end

  describe "autor (L1)" do
    before { sign_in_as(l1) }

    it "su resumen cuenta su entrada lista y no su borrador; su cronología muestra las dos" do
      get person_path(p)

      expect(summary_dimensions).to eq([ "Trabajo en equipo" ])
      expect(timeline_rows.size).to eq(2)
      expect(response.body).to include(ready_text, draft_text)
    end

    it "su conteo de P cuenta solo la entrada lista, y Q no tiene entradas" do
      get people_path

      expect(count_for("Ada Ejemplo")).to eq("1 entrada lista")
      expect(count_for("Bruno Ejemplo")).to eq("0 entradas listas")
    end
  end

  describe "administradora asignada a P sin entradas propias (A)" do
    before { sign_in_as(admin) }

    it "no ve entradas ajenas en el resumen, la cronología ni el conteo (PP-8)" do
      get person_path(p)

      expect(summary_rows).to be_empty
      expect(timeline_rows).to be_empty
      expect(response.body).not_to include(ready_text)

      get people_path
      expect(count_for("Ada Ejemplo")).to eq("0 entradas listas")
    end
  end
end
