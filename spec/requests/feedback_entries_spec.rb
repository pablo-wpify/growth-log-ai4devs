require "rails_helper"

# Entradas de feedback por petición (GL-06; specs feedback-capture y
# authorization). Datos ficticios propios de cada prueba: no usan la base de
# desarrollo ni la tarea de GL-08.
#
# Actores: L1 y L2 asignados a P; L3 sin asignación; A administradora, sin
# asignación y, en otra prueba, asignada a P; I persona inactiva con
# asignación de L1.
RSpec.describe "Entradas de feedback", type: :request do
  let!(:l1) { create_user(email_address: "luis.lider@example.test", name: "Luis Líder") }
  let!(:l2) { create_user(email_address: "lara.lider@example.test", name: "Lara Líder") }
  let!(:l3) { create_user(email_address: "leo.lider@example.test", name: "Leo Líder") }
  let!(:admin) { create_user(email_address: "ana.admin@example.test", name: "Ana Admin", admin: true) }

  let!(:p) { create_person(name: "Ada Ejemplo", role: "Desarrolladora", team: "Equipo Faro") }
  let!(:inactive) { create_person(name: "Iris Inactiva", active: false) }
  let!(:l1_assignment) { assign(l1, p) }

  # Textos únicos de cada entrada, para buscarlos en las respuestas.
  let(:draft_text) { "Contexto-borrador-#{SecureRandom.hex(4)}" }
  let(:ready_text) { "Contexto-lista-#{SecureRandom.hex(4)}" }
  let(:secret_evidence) { "Evidencia-#{SecureRandom.hex(4)}" }

  let!(:draft) do
    FeedbackEntry.create!(author: l1, person: p, occurred_on: Date.new(2026, 11, 10), context: draft_text,
                          evidence: secret_evidence)
  end
  let!(:ready) do
    FeedbackEntry.create!(author: l1, person: p, occurred_on: Date.new(2026, 11, 5), context: ready_text,
                          status: "ready", dimension: "teamwork", signal: "positive", impact: "Impacto visible", confidence: 4)
  end

  before do
    assign(l2, p)
    assign(l1, inactive)
  end

  def page = Nokogiri::HTML(response.body)
  def snapshot = FeedbackEntry.order(:id).map(&:attributes)

  def missing_id = FeedbackEntry.maximum(:id).to_i + 1000

  def complete_params(**overrides)
    { feedback_entry: {
      occurred_on: "2026-11-11", context: "Contexto completo", signal: "improvement", dimension: "delivery",
      evidence: "Evidencia nueva", impact: "Impacto nuevo", confidence: "3"
    }.merge(overrides) }
  end

  describe "captura rápida (3.1, 3.2, P-19, P-22)" do
    before { sign_in_as(l1) }

    it "abre la página de captura con el texto, la fecha de hoy y la vuelta a la ficha" do
      get new_person_feedback_entry_path(p)

      expect(response).to have_http_status(:ok)
      expect(page.at_css("main h1").text).to include("Captura rápida sobre Ada Ejemplo")
      expect(page.at_css("textarea[name='feedback_entry[context]']")).to be_present
      expect(page.text).to include("Fecha: hoy, #{Time.zone.today.strftime('%d/%m/%Y')}")
      expect(page.at_css("a[href='#{person_path(p)}']").text).to include("← Volver a Ada Ejemplo")
      expect(page.css("input[name^='feedback_entry[']:not([type=hidden])")).to be_empty
    end

    it "guarda un borrador del autor sobre la persona con la fecha de hoy y vuelve a la ficha con el aviso" do
      expect {
        post person_feedback_entries_path(p), params: { feedback_entry: { context: "Resolvió el incidente" } }
      }.to change(FeedbackEntry, :count).by(1)

      entry = FeedbackEntry.order(:id).last
      expect(entry).to have_attributes(author: l1, person: p, status: "draft", occurred_on: Time.zone.today,
                                       context: "Resolvió el incidente")
      expect(response).to redirect_to(person_path(p))
      expect(flash[:notice]).to eq("Guardamos tu borrador. Solo vos podés verlo.")
    end

    it "ignora el autor, la persona, el estado y los demás campos que se envíen en la captura" do
      post person_feedback_entries_path(p), params: { feedback_entry: {
        context: "Texto", author_id: l2.id, person_id: inactive.id, status: "ready", signal: "positive",
        dimension: "teamwork", occurred_on: "2020-01-01"
      } }

      expect(FeedbackEntry.order(:id).last).to have_attributes(author: l1, person: p, status: "draft",
                                                               signal: nil, dimension: nil, occurred_on: Time.zone.today)
    end

    it "sin texto responde 422, muestra el error y no guarda nada" do
      expect {
        post person_feedback_entries_path(p), params: { feedback_entry: { context: "   " } }
      }.not_to change(FeedbackEntry, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Contá qué pasó.")
    end
  end

  describe "captura sin permiso de escritura (2.10, P-20)" do
    it "un líder sin asignación recibe 404 y no se crea ninguna entrada" do
      sign_in_as(l3)

      get new_person_feedback_entry_path(p)
      expect(response).to have_http_status(:not_found)
      expect {
        post person_feedback_entries_path(p), params: { feedback_entry: { context: "Intento" } }
      }.not_to change(FeedbackEntry, :count)
      expect(response).to have_http_status(:not_found)
    end

    it "una administradora, asignada o no, recibe 404 y no se crea ninguna entrada" do
      sign_in_as(admin)
      expect { post person_feedback_entries_path(p), params: { feedback_entry: { context: "Intento" } } }
        .not_to change(FeedbackEntry, :count)
      expect(response).to have_http_status(:not_found)
    end

    it "un líder asignado a una persona inactiva recibe 404 y no se crea ninguna entrada" do
      sign_in_as(l1)

      get new_person_feedback_entry_path(inactive)
      expect(response).to have_http_status(:not_found)
      expect { post person_feedback_entries_path(inactive), params: { feedback_entry: { context: "Intento" } } }
        .not_to change(FeedbackEntry, :count)
      expect(response).to have_http_status(:not_found)
    end

    it "con la asignación terminada recibe 404 y no se crea ninguna entrada" do
      l1_assignment.update!(ended_at: Time.current)
      sign_in_as(l1)

      expect { post person_feedback_entries_path(p), params: { feedback_entry: { context: "Intento" } } }
        .not_to change(FeedbackEntry, :count)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "captura con la sesión vencida (verificación pendiente de P-22)" do
    it "redirige al inicio de sesión, no crea la entrada y no recuerda la URL del envío" do
      start = Time.current
      travel_to(start) { sign_in_as(l1) }

      travel_to(start + 2.hours + 1.second) do
        expect {
          post person_feedback_entries_path(p), params: { feedback_entry: { context: "Texto escrito antes de vencer" } }
        }.not_to change(FeedbackEntry, :count)
      end

      expect(response).to redirect_to(new_session_path)
      expect(session[:return_to_after_authenticating]).to be_nil
    end
  end

  describe "detalle de una entrada propia (2.8, 4.8 parcial)" do
    before { sign_in_as(l1) }

    it "muestra el borrador con autor, fecha, estado, todos los campos y las acciones" do
      get feedback_entry_path(draft)

      expect(response).to have_http_status(:ok)
      expect(page.at_css("main h1").text).to include("Entrada sobre Ada Ejemplo")
      expect(page.text).to include("Escrita por vos (Luis Líder)", "10/11/2026", "Borrador · solo vos", draft_text, secret_evidence)
      expect(page.text).to include("Contexto", "Señal", "Dimensión", "Evidencia", "Impacto", "Confianza", "Sin indicar")
      expect(page.at_css("a[href='#{edit_feedback_entry_path(draft)}']").text).to include("Editar")
      expect(page.at_css("form[action='#{mark_ready_feedback_entry_path(draft)}'] button").text).to include("Marcar como lista")
      expect(page.at_css("a[href='#{person_path(p)}']").text).to include("← Volver a Ada Ejemplo")
    end

    it "muestra la entrada lista con sus etiquetas, «Editar» y el enlace a la ficha, sin «Marcar como lista»" do
      get feedback_entry_path(ready)

      expect(page.text).to include("Lista · solo vos", ready_text, "Trabajo en equipo", "Positivo", "Impacto visible", "4")
      expect(page.at_css("a[href='#{edit_feedback_entry_path(ready)}']")).to be_present
      expect(page.at_css("a[href='#{person_path(p)}']")).to be_present
      expect(page.at_css("form[action='#{mark_ready_feedback_entry_path(ready)}']")).to be_nil
    end
  end

  describe "completar un borrador (3.4, 2.3 a 2.5)" do
    before { sign_in_as(l1) }

    it "abre el formulario de edición con los campos y las opciones «Sin indicar»" do
      get edit_feedback_entry_path(draft)

      expect(response).to have_http_status(:ok)
      %w[occurred_on context evidence impact confidence].each do |field|
        expect(page.at_css("[name='feedback_entry[#{field}]']")).to be_present, "falta #{field}"
      end
      expect(page.css("input[type=radio][name='feedback_entry[signal]']").map { |i| i["value"] }).to eq([ "", "positive", "improvement", "neutral" ])
      expect(page.css("input[type=radio][name='feedback_entry[dimension]']").map { |i| i["value"] })
        .to eq([ "" ] + FeedbackEntry::DIMENSIONS.keys)
    end

    # F17 (14/11/2026): las etiquetas apuntaban a un id inexistente
    # («…_positive_positive»), así que el texto no seleccionaba la opción, los
    # radios no tenían nombre accesible y, al pasar de línea, cada radio quedaba
    # separado de su texto. Cada radio va dentro de su etiqueta y, si la
    # etiqueta tiene «for», apunta al id real del radio.
    it "asocia cada opción de señal y dimensión con su texto" do
      get edit_feedback_entry_path(draft)

      expected = {
        "signal" => { "" => "Sin indicar" }.merge(FeedbackEntry::SIGNALS),
        "dimension" => { "" => "Sin indicar" }.merge(FeedbackEntry::DIMENSIONS)
      }
      expected.each do |attribute, labels|
        radios = page.css("input[type=radio][name='feedback_entry[#{attribute}]']")
        expect(radios.map { |radio| radio["value"] }).to eq(labels.keys)
        radios.each do |radio|
          label = radio.ancestors("label").first
          expect(label).to be_present, "el radio #{radio['id']} no está dentro de su etiqueta"
          expect(label.text.strip).to eq(labels.fetch(radio["value"]))
          expect(label["for"]).to eq(radio["id"]) if label["for"]
          expect(radio["id"]).to be_present
          expect(page.css("label[for='#{radio['id']}']").size).to be <= 1
        end
      end
      expect(page.css("fieldset.choices label").map { |label| label["for"] }.compact)
        .to all(satisfy { |target| page.at_css("input[type=radio]##{target}") })
    end

    it "guarda los datos y la entrada sigue como borrador" do
      patch feedback_entry_path(draft), params: complete_params

      expect(response).to redirect_to(feedback_entry_path(draft))
      expect(flash[:notice]).to eq("Guardamos los cambios. Solo vos podés ver esta entrada.")
      expect(draft.reload).to have_attributes(status: "draft", occurred_on: Date.new(2026, 11, 11), context: "Contexto completo",
                                              signal: "improvement", dimension: "delivery", evidence: "Evidencia nueva",
                                              impact: "Impacto nuevo", confidence: 3)
    end

    it "sin fecha o sin contexto responde 422, muestra el error y la entrada no cambia" do
      before = snapshot

      patch feedback_entry_path(draft), params: complete_params(occurred_on: "")
      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Indicá la fecha del hecho.")

      patch feedback_entry_path(draft), params: complete_params(context: "")
      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Contá qué pasó.")

      expect(snapshot).to eq(before)
    end

    it "ignora otro autor, otra persona y el estado lista" do
      patch feedback_entry_path(draft), params: complete_params(author_id: l2.id, person_id: inactive.id, status: "ready")

      expect(draft.reload).to have_attributes(author: l1, person: p, status: "draft")
    end
  end

  describe "marcar como lista (2.6, 3.5, 3.6, P-3, P-25)" do
    before { sign_in_as(l1) }

    it "un borrador con dimensión y señal pasa a lista con el aviso de que sigue privada" do
      draft.update!(dimension: "delivery", signal: "neutral")

      patch mark_ready_feedback_entry_path(draft)

      expect(response).to redirect_to(feedback_entry_path(draft))
      expect(flash[:notice]).to eq("La entrada está lista y sigue siendo privada: solo vos podés verla.")
      expect(draft.reload).to be_ready
    end

    it "sin dimensión ni señal responde 422, indica las dos y no cambia nada" do
      before = snapshot

      patch mark_ready_feedback_entry_path(draft)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Para marcarla como lista falta: dimensión y señal.")
      expect(snapshot).to eq(before)
    end

    it "con dimensión y sin señal responde 422, indica la señal y no cambia nada" do
      draft.update!(dimension: "delivery")
      before = snapshot

      patch mark_ready_feedback_entry_path(draft)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Para marcarla como lista falta: señal.")
      expect(snapshot).to eq(before)
    end

    it "sobre una entrada que ya está lista no la cambia y vuelve al detalle sin error (P-25)" do
      before = snapshot

      patch mark_ready_feedback_entry_path(ready)

      expect(response).to redirect_to(feedback_entry_path(ready))
      expect(flash[:alert]).to be_nil
      expect(snapshot).to eq(before)
    end
  end

  describe "editar una entrada lista (3.7, P-3)" do
    before { sign_in_as(l1) }

    it "guarda el cambio y sigue lista" do
      patch feedback_entry_path(ready), params: { feedback_entry: { evidence: "Nueva evidencia" } }

      expect(ready.reload).to have_attributes(status: "ready", evidence: "Nueva evidencia")
    end

    it "quitarle la señal responde 422, indica la señal y no cambia nada" do
      before = snapshot

      patch feedback_entry_path(ready), params: { feedback_entry: { signal: "" } }

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Para que la entrada esté lista falta la señal.")
      expect(snapshot).to eq(before)
    end
  end

  # Matriz de privacidad (diseño, «Verificación»; 2.9, 3.8, 4.9, 4.11, PP-3,
  # PP-4, PP-8). Cada celda sobre el borrador y sobre la entrada lista.
  describe "matriz de privacidad por URL directa" do
    FEEDBACK_REQUESTS = {
      "detalle" => ->(spec, entry) { spec.get spec.feedback_entry_path(entry) },
      "formulario de edición" => ->(spec, entry) { spec.get spec.edit_feedback_entry_path(entry) },
      "edición" => ->(spec, entry) { spec.patch spec.feedback_entry_path(entry), params: { feedback_entry: { context: "Pisado" } } },
      "marcar como lista" => ->(spec, entry) { spec.patch spec.mark_ready_feedback_entry_path(entry) }
    }.freeze

    def not_found_reference
      get feedback_entry_path(missing_id)
      [ response.status, response.body ]
    end

    def expect_denied(actor)
      sign_in_as(actor)
      reference = not_found_reference

      [ draft, ready ].each do |entry|
        FEEDBACK_REQUESTS.each do |name, request|
          before = snapshot
          request.call(self, entry)

          expect([ response.status, response.body ]).to eq(reference), "#{actor.name}: #{name} de #{entry.status} no respondió como inexistente"
          expect(response.body).not_to include(entry.context)
          expect(response.body).not_to include(secret_evidence)
          expect(snapshot).to eq(before), "#{actor.name}: #{name} de #{entry.status} cambió la base"
        end
      end
    end

    it "una entrada inexistente responde 404" do
      sign_in_as(l1)

      expect(not_found_reference.first).to eq(404)
    end

    it "L2, asignado a la misma persona, recibe 404 como inexistente, sin el texto y sin cambios" do
      expect_denied(l2)
    end

    it "L3, sin asignación, recibe 404 como inexistente, sin el texto y sin cambios" do
      expect_denied(l3)
    end

    it "A, administradora sin asignación, recibe 404 como inexistente, sin el texto y sin cambios" do
      expect_denied(admin)
    end

    it "A, administradora asignada a la persona, recibe 404 como inexistente, sin el texto y sin cambios" do
      assign(admin, p)

      expect_denied(admin)
    end
  end

  # Autor sin acceso a la ficha (P-24): lectura por URL directa con todos los
  # campos y, de la persona, solo el nombre; sin escritura. Trazabilidad:
  # 3.10 y 4.14 (parciales) y la lectura de entradas propias de la rama de
  # lectura de PT-11, sin dar por resuelta «con datos mínimos».
  shared_examples "autor sin acceso a la ficha" do
    it "lee su borrador y su entrada lista con todos los campos y solo el nombre de la persona" do
      sign_in_as(l1)

      [ draft, ready ].each do |entry|
        get feedback_entry_path(entry)

        expect(response).to have_http_status(:ok)
        expect(page.text).to include("Ada Ejemplo", entry.context, "Ya no acompañás a esta persona: podés leer esta entrada, pero no editarla.")
        expect(page.text).not_to include("Desarrolladora", "Equipo Faro")
        expect(page.at_css("a[href='#{person_path(p)}']")).to be_nil
        expect(page.at_css("a[href='#{edit_feedback_entry_path(entry)}']")).to be_nil
        expect(page.css("main form")).to be_empty
      end
      expect(page.text).to include("Trabajo en equipo", "Positivo", "Impacto visible")
    end

    it "no puede editar ni marcar como lista: 404 y sin cambios" do
      sign_in_as(l1)
      before = snapshot

      [ draft, ready ].each do |entry|
        get edit_feedback_entry_path(entry)
        expect(response).to have_http_status(:not_found)
        patch feedback_entry_path(entry), params: { feedback_entry: { context: "Pisado" } }
        expect(response).to have_http_status(:not_found)
        patch mark_ready_feedback_entry_path(entry)
        expect(response).to have_http_status(:not_found)
      end
      expect(snapshot).to eq(before)
    end

    it "la ficha de la persona responde 404" do
      sign_in_as(l1)
      get person_path(p)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "L1 con la asignación terminada" do
    before { l1_assignment.update!(ended_at: Time.current) }

    include_examples "autor sin acceso a la ficha"
  end

  describe "L1 con la persona inactiva" do
    before { p.update!(active: false) }

    include_examples "autor sin acceso a la ficha"
  end
end
