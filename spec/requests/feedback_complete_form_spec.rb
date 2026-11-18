require "rails_helper"

# Formulario completo «+ Feedback» por petición (GL-15; delta de
# feedback-capture y people-browsing). Tareas 1.1 y 1.2. Datos ficticios
# propios de cada prueba.
#
# Actores: L1 y L2 asignados a P; L3 sin asignación; I persona inactiva con
# asignación de L1.
RSpec.describe "Formulario completo «+ Feedback»", type: :request do
  let!(:l1) { create_user(email_address: "luis.lider@example.test", name: "Luis Líder") }
  let!(:l2) { create_user(email_address: "lara.lider@example.test", name: "Lara Líder") }
  let!(:l3) { create_user(email_address: "leo.lider@example.test", name: "Leo Líder") }

  let!(:p) { create_person(name: "Ada Ejemplo", role: "Desarrolladora", team: "Equipo Faro") }
  let!(:inactive) { create_person(name: "Iris Inactiva", active: false) }

  before do
    assign(l1, p)
    assign(l2, p)
    assign(l1, inactive)
  end

  let(:context_text) { "Contexto-formulario-#{SecureRandom.hex(4)}" }

  def page = Nokogiri::HTML(response.body)
  def form_path(person) = "/personas/#{person.id}/entradas/completa"

  def entry_params(**overrides)
    { feedback_entry: {
      occurred_on: "2026-11-10", context: context_text, signal: "positive", dimension: "teamwork",
      evidence: "Evidencia del formulario", impact: "Impacto del formulario", confidence: "4", status: "ready"
    }.merge(overrides) }
  end

  describe "acceso y apertura (2.1, 2.2, 2.10)" do
    it "la ficha ofrece «Captura rápida» como acción principal y «+ Feedback» como acción secundaria" do
      sign_in_as(l1)
      get person_path(p)

      capture = page.at_css(".person-actions .primary-action a")
      complete = page.at_css(".person-actions .secondary-action a")
      expect(capture.text.strip).to eq("Captura rápida")
      expect(capture["class"].split).to include("button-primary")
      expect(complete.text.strip).to eq("+ Feedback")
      expect(complete["href"]).to eq(form_path(p))
      expect(complete["data-turbo-frame"]).to eq("feedback_form")
      expect(complete["class"].split).not_to include("button-primary")
      expect(page.at_css("turbo-frame#feedback_form")).to be_present
      expect(page.css("turbo-frame#feedback_form form")).to be_empty
    end

    it "el formulario tiene todos los campos, los dos botones, «Cancelar» y la fecha precargada de hoy" do
      sign_in_as(l1)
      get form_path(p)

      expect(response).to have_http_status(:ok)
      frame = page.at_css("turbo-frame#feedback_form")
      form = frame.at_css("form")
      expect(form["action"]).to eq(form_path(p))
      expect(form["data-turbo-frame"]).to eq("_top")
      %w[occurred_on context signal dimension evidence impact confidence].each do |field|
        expect(form.css("[name='feedback_entry[#{field}]']")).not_to be_empty, "falta el campo #{field}"
      end
      buttons = form.css("button[name='feedback_entry[status]']").map { |button| [ button.text.strip, button["value"] ] }
      expect(buttons).to eq([ [ "Guardar borrador", "draft" ], [ "Guardar como lista", "ready" ] ])
      expect(frame.at_css("a", text: "Cancelar")["href"]).to eq(person_path(p))
      expect(form.at_css("input[name='feedback_entry[occurred_on]']")["value"]).to eq(Time.zone.today.iso8601)
      expect(response.body).not_to include("Publicar")
    end

    it "a las 22:00 de Buenos Aires, cuando en UTC ya es el día siguiente, precarga la fecha de Buenos Aires (P-23)" do
      travel_to(Time.utc(2026, 11, 13, 1, 0)) do # 12/11/2026 22:00 en Buenos Aires
        sign_in_as(l1)
        get form_path(p)
      end

      expect(page.at_css("input[name='feedback_entry[occurred_on]']")["value"]).to eq("2026-11-12")
    end

    it "sin asignación activa o con la persona inactiva responde 404, también por URL directa" do
      sign_in_as(l3)
      get form_path(p)
      expect(response).to have_http_status(:not_found)

      sign_in_as(l1)
      get form_path(inactive)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "guardado (2.2 a 2.10, P-3)" do
    it "«Guardar borrador» guarda sin señal ni dimensión y vuelve a la ficha con el aviso" do
      sign_in_as(l1)

      expect {
        post form_path(p), params: entry_params(signal: "", dimension: "", status: "draft")
      }.to change(FeedbackEntry, :count).by(1)

      entry = FeedbackEntry.order(:id).last
      expect(entry).to be_draft
      expect(entry.signal).to be_nil
      expect(entry.dimension).to be_nil
      expect(response).to redirect_to(person_path(p))
      expect(flash[:notice]).to eq("Guardamos tu borrador. Solo vos podés verlo.")
    end

    it "«Guardar como lista» guarda la entrada completa y el aviso confirma sin el texto ni la persona" do
      sign_in_as(l1)
      post form_path(p), params: entry_params

      entry = FeedbackEntry.order(:id).last
      expect(entry).to have_attributes(author: l1, person: p, status: "ready", context: context_text,
                                       signal: "positive", dimension: "teamwork", confidence: 4,
                                       evidence: "Evidencia del formulario", impact: "Impacto del formulario")
      expect(response).to redirect_to(person_path(p))
      expect(flash[:notice]).to eq("Feedback guardado como lista.")
      expect(flash[:notice]).not_to include(context_text)
      expect(flash[:notice]).not_to include(p.name)

      follow_redirect!
      expect(page.at_css(".flash-notice").text).to eq("Feedback guardado como lista.")
      expect(response.body).not_to include("Publicar")
    end

    it "guarda la fecha elegida, no la de hoy" do
      sign_in_as(l1)
      post form_path(p), params: entry_params(occurred_on: "2026-10-01")

      expect(FeedbackEntry.order(:id).last.occurred_on).to eq(Date.new(2026, 10, 1))
    end

    it "sin estado, guarda un borrador (valor por defecto del modelo)" do
      sign_in_as(l1)
      params = entry_params
      params[:feedback_entry].delete(:status)
      post form_path(p), params: params

      expect(FeedbackEntry.order(:id).last).to be_draft
      expect(response).to redirect_to(person_path(p))
    end

    it "un estado desconocido es un error de validación y no se guarda" do
      sign_in_as(l1)

      expect {
        post form_path(p), params: entry_params(status: "shared")
      }.not_to change(FeedbackEntry, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(page.at_css("turbo-frame#feedback_form form")).to be_present
      expect(response.body).to include("Elegí cómo guardar la entrada: borrador o lista.")
    end

    it "como lista sin dimensión ni señal no guarda y vuelve a mostrar el formulario con lo cargado y lo que falta" do
      sign_in_as(l1)

      expect {
        post form_path(p), params: entry_params(signal: "", dimension: "")
      }.not_to change(FeedbackEntry, :count)

      expect(response).to have_http_status(:unprocessable_content)
      form = page.at_css("turbo-frame#feedback_form form")
      expect(form.at_css("textarea[name='feedback_entry[context]']").text).to include(context_text)
      expect(response.body).to include("falta la dimensión")
      expect(response.body).to include("falta la señal")
      expect(page.at_css("main h1").text).to include("Ada Ejemplo")
    end

    it "la ficha con errores conserva «Personas» como página actual en la navegación, como la ficha normal" do
      sign_in_as(l1)
      post form_path(p), params: entry_params(signal: "", dimension: "")

      expect(response).to have_http_status(:unprocessable_content)
      current = page.at_css("header a[aria-current='page']")
      expect(current&.text&.strip).to eq("Personas")
      expect(current["href"]).to eq(people_path)
    end

    it "como lista con dimensión y sin señal indica que falta la señal" do
      sign_in_as(l1)

      expect {
        post form_path(p), params: entry_params(signal: "")
      }.not_to change(FeedbackEntry, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("falta la señal")
      expect(response.body).not_to include("falta la dimensión")
    end

    it "sin contexto o sin fecha no guarda, como borrador o como lista" do
      sign_in_as(l1)

      [ { context: "" }, { occurred_on: "" } ].product(%w[draft ready]).each do |override, status|
        expect {
          post form_path(p), params: entry_params(**override, status: status)
        }.not_to change(FeedbackEntry, :count)
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    it "ignora otro autor y otra persona en los parámetros" do
      sign_in_as(l1)
      post form_path(p), params: entry_params(author_id: l2.id, person_id: inactive.id)

      entry = FeedbackEntry.order(:id).last
      expect(entry.author).to eq(l1)
      expect(entry.person).to eq(p)
    end

    it "sin asignación responde 404 y no crea ninguna entrada" do
      sign_in_as(l3)

      expect {
        post form_path(p), params: entry_params
      }.not_to change(FeedbackEntry, :count)
      expect(response).to have_http_status(:not_found)

      sign_in_as(l1)
      expect {
        post form_path(inactive), params: entry_params
      }.not_to change(FeedbackEntry, :count)
      expect(response).to have_http_status(:not_found)
    end

    it "otro líder de la misma persona no ve la entrada en la ficha y recibe 404 en el detalle" do
      sign_in_as(l1)
      post form_path(p), params: entry_params
      entry = FeedbackEntry.order(:id).last

      sign_in_as(l2)
      get person_path(p)
      expect(response.body).not_to include(context_text)

      get feedback_entry_path(entry)
      expect(response).to have_http_status(:not_found)
      expect(response.body).not_to include(context_text)
    end
  end
end
