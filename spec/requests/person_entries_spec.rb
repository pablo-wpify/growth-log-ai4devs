require "rails_helper"

# Sección «Tus entradas sobre <nombre>» en la ficha (GL-06, P-21; 4.11) y
# textos que separan «lista» de «compartida» (RN-2). Datos ficticios propios
# de cada prueba.
RSpec.describe "Entradas propias en la ficha", type: :request do
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

  def section_rows
    page.css("[data-own-entries] li")
  end

  it "muestra los borradores y las entradas listas propias, con fecha, estado, comienzo del texto y enlace al detalle" do
    draft = create_entry(l1, context: "Resolvió el incidente del lunes con calma")
    ready = create_entry(l1, context: "Presentó la demo", occurred_on: Date.new(2026, 11, 5),
                             status: "ready", dimension: "delivery", signal: "positive")

    sign_in_as(l1)
    get person_path(ada)

    expect(page.at_css("[data-own-entries] h2").text).to eq("Tus entradas sobre Ada Ejemplo")
    expect(section_rows.size).to eq(2)
    expect(section_rows[0].text).to include("12/11/2026", "Borrador · solo vos", "Resolvió el incidente")
    expect(section_rows[1].text).to include("05/11/2026", "Lista · solo vos", "Presentó la demo")
    expect(section_rows[0].at_css("a")["href"]).to eq(feedback_entry_path(draft))
    expect(section_rows[1].at_css("a")["href"]).to eq(feedback_entry_path(ready))
  end

  it "no muestra las entradas de otro líder de la misma persona (4.11)" do
    create_entry(l1, context: "Entrada de Luis")
    create_entry(l2, context: "Entrada privada de Lara")

    sign_in_as(l1)
    get person_path(ada)

    expect(section_rows.size).to eq(1)
    expect(response.body).not_to include("Entrada privada de Lara")
  end

  # P-21: fecha del hecho descendente; en empate, primero la creada después.
  # La fecha de creación contradice el orden de los ids a propósito, para que
  # la prueba falle si el desempate usara el id.
  it "ordena por fecha del hecho descendente y, en empate, primero la creada después (P-21)" do
    earlier_date = create_entry(l1, context: "Fecha anterior", occurred_on: Date.new(2026, 11, 1))
    created_later = create_entry(l1, context: "Mismo día, id menor, creada después")
    created_earlier = create_entry(l1, context: "Mismo día, id mayor, creada antes")
    created_later.update_columns(created_at: 1.hour.ago)
    created_earlier.update_columns(created_at: 2.hours.ago)
    expect(created_later.id).to be < created_earlier.id

    sign_in_as(l1)
    get person_path(ada)

    expect(section_rows.map { |row| row.at_css("a")["href"] }).to eq([
      feedback_entry_path(created_later), feedback_entry_path(created_earlier), feedback_entry_path(earlier_date)
    ])
  end

  it "muestra solo los primeros 80 caracteres del texto" do
    long_text = "a" * 80 + "FINAL-OCULTO"
    create_entry(l1, context: long_text)

    sign_in_as(l1)
    get person_path(ada)

    expect(section_rows.first.text).to include("a" * 80)
    expect(section_rows.first.text).not_to include("FINAL-OCULTO")
  end

  it "sin entradas propias muestra un mensaje" do
    create_entry(l2, context: "Entrada de Lara")

    sign_in_as(l1)
    get person_path(ada)

    expect(section_rows).to be_empty
    expect(page.at_css("[data-own-entries]").text).to include("Todavía no registraste entradas sobre Ada Ejemplo.")
  end

  describe "textos (RN-2)" do
    it "ninguna página de entradas dice «Publicar» y los estados y avisos dicen que solo el autor la ve" do
      sign_in_as(l1)

      post person_feedback_entries_path(ada), params: { feedback_entry: { context: "Captura de texto" } }
      entry = FeedbackEntry.order(:id).last
      follow_redirect!
      expect(page.at_css(".flash-notice").text).to eq("Guardamos tu borrador. Solo vos podés verlo.")

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
      expect(page.text).to include("Lista · solo vos")
    end
  end
end
