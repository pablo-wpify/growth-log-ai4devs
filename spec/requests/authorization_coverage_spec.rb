require "rails_helper"

# Cobertura de autorización con sesión (GL-03). Complementa
# route_protection_spec, que recorre las rutas sin sesión. Cada ruta del
# producto se prepara en ROUTES con un actor autorizado y uno sin permisos.
# Con el actor autorizado la acción termina, y así corren las verificaciones
# de Pundit: si falta `authorize` o `policy_scope`, la petición falla. Una
# ruta sin preparar hace fallar la prueba.
RSpec.describe "Cobertura de autorización con sesión", type: :request do
  # Rutas sin cuenta identificada, exceptuadas por acción (GL-02 y GL-03).
  EXEMPT_ROUTES = [
    [ "GET", "/up" ],
    [ "GET", "/session/new" ],
    [ "POST", "/session" ]
  ].freeze

  # Para cada ruta: cómo pedirla y qué esperar de cada actor. En cada
  # ejemplo existe «Ada Ejemplo», asignada solo al actor autorizado (GL-05).
  # El actor sin permisos ve el listado vacío y recibe 404 en la ficha. El
  # cierre de sesión es igual para toda cuenta identificada.
  LISTS_ASSIGNED = ->(spec) do
    spec.expect(spec.response).to spec.have_http_status(:ok)
    spec.expect(spec.response.body).to spec.include("Ada Ejemplo")
  end
  LISTS_NOTHING = ->(spec) do
    spec.expect(spec.response).to spec.have_http_status(:ok)
    spec.expect(spec.response.body).not_to spec.include("Ada Ejemplo")
    spec.expect(spec.response.body).to spec.include("Todavía no tenés personas asignadas.")
  end

  # Entradas (GL-06): el actor autorizado es el autor de `entry`; el actor
  # sin permisos es otro líder asignado a la misma persona (4.11), por eso
  # esas rutas lo asignan antes de la petición. Recibe 404 sin el texto.
  ENTRY_DENIED = ->(spec) do
    spec.expect(spec.response).to spec.have_http_status(:not_found)
    spec.expect(spec.response.body).not_to spec.include(spec.entry.context)
  end
  ASSIGN_TO_ADA = ->(spec, actor) { spec.assign(actor, spec.person) }

  ROUTES = {
    [ "GET", "/personas/:person_id/entradas/nueva" ] => {
      request: ->(spec) { spec.get "/personas/#{spec.person.id}/entradas/nueva" },
      authorized: ->(spec) { spec.expect(spec.response).to spec.have_http_status(:ok) },
      unauthorized: ->(spec) { spec.expect(spec.response).to spec.have_http_status(:not_found) }
    },
    [ "POST", "/personas/:person_id/entradas" ] => {
      request: ->(spec) { spec.post "/personas/#{spec.person.id}/entradas", params: { feedback_entry: { context: "Captura de cobertura" } } },
      authorized: ->(spec) do
        spec.expect(spec.response).to spec.redirect_to("/personas/#{spec.person.id}")
        spec.expect(FeedbackEntry.where(context: "Captura de cobertura").count).to spec.eq(1)
      end,
      unauthorized: ->(spec) do
        spec.expect(spec.response).to spec.have_http_status(:not_found)
        spec.expect(FeedbackEntry.where(context: "Captura de cobertura")).to spec.be_empty
      end
      # Sin preparar: en la captura, el actor sin permisos es un líder sin
      # asignación. Un líder asignado sí puede crear su propia entrada.
    },
    [ "GET", "/entradas/:id" ] => {
      request: ->(spec) { spec.get "/entradas/#{spec.entry.id}" },
      authorized: ->(spec) do
        spec.expect(spec.response).to spec.have_http_status(:ok)
        spec.expect(spec.response.body).to spec.include(spec.entry.context)
      end,
      unauthorized: ENTRY_DENIED,
      prepare_unauthorized: ASSIGN_TO_ADA
    },
    [ "GET", "/entradas/:id/editar" ] => {
      request: ->(spec) { spec.get "/entradas/#{spec.entry.id}/editar" },
      authorized: ->(spec) { spec.expect(spec.response).to spec.have_http_status(:ok) },
      unauthorized: ENTRY_DENIED,
      prepare_unauthorized: ASSIGN_TO_ADA
    },
    [ "PATCH", "/entradas/:id" ] => {
      request: ->(spec) { spec.patch "/entradas/#{spec.entry.id}", params: { feedback_entry: { evidence: "Evidencia de cobertura" } } },
      authorized: ->(spec) do
        spec.expect(spec.response).to spec.redirect_to("/entradas/#{spec.entry.id}")
        spec.expect(spec.entry.reload.evidence).to spec.eq("Evidencia de cobertura")
      end,
      unauthorized: ->(spec) do
        ENTRY_DENIED.call(spec)
        spec.expect(spec.entry.reload.evidence).to spec.be_nil
      end,
      prepare_unauthorized: ASSIGN_TO_ADA
    },
    [ "PATCH", "/entradas/:id/marcar-lista" ] => {
      request: ->(spec) { spec.patch "/entradas/#{spec.entry.id}/marcar-lista" },
      authorized: ->(spec) do
        spec.expect(spec.response).to spec.redirect_to("/entradas/#{spec.entry.id}")
        spec.expect(spec.entry.reload).to spec.be_ready
      end,
      unauthorized: ->(spec) do
        ENTRY_DENIED.call(spec)
        spec.expect(spec.entry.reload).to spec.be_draft
      end,
      prepare_unauthorized: ASSIGN_TO_ADA
    },
    [ "GET", "/" ] => {
      request: ->(spec) { spec.get "/" },
      authorized: LISTS_ASSIGNED,
      unauthorized: LISTS_NOTHING
    },
    [ "GET", "/personas" ] => {
      request: ->(spec) { spec.get "/personas" },
      authorized: LISTS_ASSIGNED,
      unauthorized: LISTS_NOTHING
    },
    [ "GET", "/personas/:id" ] => {
      request: ->(spec) { spec.get "/personas/#{spec.person.id}" },
      authorized: LISTS_ASSIGNED,
      unauthorized: ->(spec) do
        spec.expect(spec.response).to spec.have_http_status(:not_found)
        spec.expect(spec.response.body).not_to spec.include("Ada Ejemplo")
      end
    },
    [ "DELETE", "/session" ] => {
      request: ->(spec) { spec.delete "/session" },
      authorized: ->(spec) { spec.expect(spec.response).to spec.redirect_to(spec.new_session_path) },
      unauthorized: ->(spec) { spec.expect(spec.response).to spec.redirect_to(spec.new_session_path) }
    }
  }.freeze

  def product_routes
    Rails.application.routes.routes.filter_map do |route|
      next unless route.defaults[:controller]

      verb = route.verb.presence || "GET"
      path = route.path.spec.to_s.sub("(.:format)", "")
      [ verb, path ] unless EXEMPT_ROUTES.include?([ verb, path ])
    end.uniq
  end

  it "tiene preparadas todas las rutas del producto, y ninguna más" do
    expect(product_routes).to match_array(ROUTES.keys)
  end

  let!(:leader) { create_user(email_address: "luis.lider@example.test") }
  let!(:person) { create_person(name: "Ada Ejemplo") }

  before { assign(leader, person) }

  # Borrador completo de `leader` sobre Ada, para las rutas de entradas.
  let!(:entry) do
    FeedbackEntry.create!(author: leader, person: person, occurred_on: Date.new(2026, 11, 12),
                          context: "Contexto-cobertura-#{SecureRandom.hex(4)}", dimension: "teamwork", signal: "positive")
  end

  ROUTES.each do |(verb, path), setup|
    describe "#{verb} #{path}" do
      it "con un actor autorizado termina sin omisiones de autorización" do
        sign_in_as(leader)

        setup[:request].call(self)

        setup[:authorized].call(self)
      end

      it "con un actor sin permisos no expone recursos" do
        actor = create_user(email_address: "lia.sinpermisos@example.test", name: "Lía Sinpermisos")
        setup[:prepare_unauthorized]&.call(self, actor)
        sign_in_as(actor)

        setup[:request].call(self)

        setup[:unauthorized].call(self)
      end
    end
  end
end
