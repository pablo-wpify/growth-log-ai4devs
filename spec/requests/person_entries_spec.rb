require "rails_helper"

# Cronología de entradas propias en la ficha (GL-07; spec `feedback-summary`:
# P-10, 4.13 parcial, 4.11, 3.3) y textos que separan «lista» de
# «compartida» (RN-2). Reemplaza la sección provisoria de P-21 (GL-06).
# Datos ficticios propios de cada prueba.
RSpec.describe "Cronología de entradas propias", type: :request do
  let!(:l1) { create_user(email_address: "luis.lider@example.test", name: "Luis Líder") }
  let!(:l2) { create_user(email_address: "lara.lider@example.test", name: "Lara Líder") }
  let!(:ada) { create_person(name: "Ada Ejemplo", role: "Desarrolladora", team: "Equipo Faro") }

  before do
    assign(l1, ada)
    assign(l2, ada)
  end

  def page = Nokogiri::HTML(response.body)

  def create_entry(author, context:, occurred_on: Date.new(2026, 11, 12), **attributes)
    FeedbackEntry.create!(author: author, person: ada, occurred_on: occurred_on, context: context, **attributes)
  end

  def timeline = page.at_css("[data-timeline]")
  def timeline_rows = page.css("[data-timeline] li")

  it "titula la sección «Vista cronológica» y ya no muestra la sección provisoria de P-21" do
    create_entry(l1, context: "Entrada de Luis")

    sign_in_as(l1)
    get person_path(ada)

    expect(timeline.at_css("h2").text).to eq("Vista cronológica")
    expect(page.text).not_to include("Tus entradas sobre")
  end

  it "muestra borradores y entradas listas con fecha, estado, señal y dimensión, comienzo del texto y enlace" do
    ready = create_entry(l1, context: "Presentó la demo", occurred_on: Date.new(2026, 11, 5),
                             status: "ready", dimension: "teamwork", signal: "positive")
    draft = create_entry(l1, context: "Resolvió el incidente del lunes con calma")

    sign_in_as(l1)
    get person_path(ada)

    expect(timeline_rows.size).to eq(2)
    expect(timeline_rows[0].text).to include("05/11/2026", "Lista · solo vos", "Positivo", "Trabajo en equipo", "Presentó la demo")
    expect(timeline_rows[1].text).to include("12/11/2026", "Borrador · solo vos · fuera del resumen", "Resolvió el incidente")
    expect(timeline_rows[0].at_css("a")["href"]).to eq(feedback_entry_path(ready))
    expect(timeline_rows[1].at_css("a")["href"]).to eq(feedback_entry_path(draft))
  end

  it "no muestra señal ni dimensión cuando la entrada no las tiene" do
    create_entry(l1, context: "Borrador sin completar")

    sign_in_as(l1)
    get person_path(ada)

    labels = FeedbackEntry::SIGNALS.values + FeedbackEntry::DIMENSIONS.values
    expect(labels.select { |label| timeline_rows.first.text.include?(label) }).to be_empty
  end

  it "muestra la señal y la dimensión de un borrador que ya las tiene" do
    create_entry(l1, context: "Borrador completo", signal: "improvement", dimension: "delivery")

    sign_in_as(l1)
    get person_path(ada)

    expect(timeline_rows.first.text).to include("Borrador · solo vos · fuera del resumen", "A mejorar", "Entrega")
  end

  it "no muestra las entradas de otro líder de la misma persona (4.11)" do
    create_entry(l1, context: "Entrada de Luis")
    create_entry(l2, context: "Entrada privada de Lara", status: "ready", dimension: "delivery", signal: "neutral")

    sign_in_as(l1)
    get person_path(ada)

    expect(timeline_rows.size).to eq(1)
    expect(response.body).not_to include("Entrada privada de Lara")
  end

  # P-10: fecha del hecho ascendente; en empate, primero la creada antes y
  # después el id. La fecha de creación contradice el orden de los ids a
  # propósito, para que la prueba falle si el desempate usara solo el id.
  it "ordena por fecha del hecho ascendente y, en empate, primero la creada antes (P-10)" do
    later_date = create_entry(l1, context: "Fecha posterior", occurred_on: Date.new(2026, 11, 20))
    created_later = create_entry(l1, context: "Mismo día, id menor, creada después")
    created_earlier = create_entry(l1, context: "Mismo día, id mayor, creada antes")
    created_later.update_columns(created_at: 1.hour.ago)
    created_earlier.update_columns(created_at: 2.hours.ago)
    expect(created_later.id).to be < created_earlier.id

    sign_in_as(l1)
    get person_path(ada)

    expect(timeline_rows.map { |row| row.at_css("a")["href"] }).to eq([
      feedback_entry_path(created_earlier), feedback_entry_path(created_later), feedback_entry_path(later_date)
    ])
  end

  it "en empate de fecha del hecho y de creación, ordena por id ascendente (P-10)" do
    first = create_entry(l1, context: "Primera")
    second = create_entry(l1, context: "Segunda")
    second.update_columns(created_at: first.created_at)

    sign_in_as(l1)
    get person_path(ada)

    expect(timeline_rows.map { |row| row.at_css("a")["href"] }).to eq([ feedback_entry_path(first), feedback_entry_path(second) ])
  end

  it "muestra solo los primeros 80 caracteres del texto" do
    long_text = "a" * 80 + "FINAL-OCULTO"
    create_entry(l1, context: long_text)

    sign_in_as(l1)
    get person_path(ada)

    expect(timeline_rows.first.text).to include("a" * 80)
    expect(timeline_rows.first.text).not_to include("FINAL-OCULTO")
  end

  it "sin entradas propias muestra un mensaje" do
    create_entry(l2, context: "Entrada de Lara")

    sign_in_as(l1)
    get person_path(ada)

    expect(timeline_rows).to be_empty
    expect(timeline.text).to include("Todavía no registraste entradas sobre Ada Ejemplo.")
  end

  describe "textos (RN-2)" do
    it "ninguna página de entradas dice «Publicar» y los estados y avisos dicen que solo el autor la ve" do
      sign_in_as(l1)

      post person_feedback_entries_path(ada), params: { feedback_entry: { context: "Captura de texto" } }
      entry = FeedbackEntry.order(:id).last
      follow_redirect!
      expect(page.at_css(".flash-notice").text).to eq("Guardamos tu borrador. Solo vos podés verlo.")
      expect(timeline.text).to include("Borrador · solo vos · fuera del resumen")

      patch feedback_entry_path(entry), params: { feedback_entry: { dimension: "teamwork", signal: "neutral" } }
      follow_redirect!
      expect(page.at_css(".flash-notice").text).to eq("Guardamos los cambios. Solo vos podés ver esta entrada.")

      patch mark_ready_feedback_entry_path(entry)
      follow_redirect!
      expect(page.at_css(".flash-notice").text).to eq("La entrada está lista y sigue siendo privada: solo vos podés verla.")
      expect(page.text).to include("Lista · solo vos")

      [ person_path(ada), new_person_feedback_entry_path(ada), feedback_entry_path(entry), edit_feedback_entry_path(entry) ].each do |path|
        get path
        expect(response).to have_http_status(:ok)
        expect(response.body).not_to match(/publicar/i), "#{path} dice «Publicar»"
      end
      get person_path(ada)
      expect(timeline.text).to include("Lista · solo vos")
    end
  end
end
