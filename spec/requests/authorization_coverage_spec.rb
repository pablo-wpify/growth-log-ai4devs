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

  # Para cada ruta: cómo pedirla y qué esperar de cada actor. La página de
  # inicio y el cierre de sesión son iguales para toda cuenta identificada:
  # no dan acceso a ningún recurso.
  ROUTES = {
    [ "GET", "/" ] => {
      request: ->(spec) { spec.get "/" },
      authorized: ->(spec) { spec.expect(spec.response).to spec.have_http_status(:ok) },
      unauthorized: ->(spec) { spec.expect(spec.response).to spec.have_http_status(:ok) }
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

  ROUTES.each do |(verb, path), setup|
    describe "#{verb} #{path}" do
      it "con un actor autorizado termina sin omisiones de autorización" do
        sign_in_as(create_user(email_address: "luis.lider@example.test"))

        setup[:request].call(self)

        setup[:authorized].call(self)
      end

      it "con un actor sin permisos no expone recursos" do
        sign_in_as(create_user(email_address: "lia.sinpermisos@example.test", name: "Lía Sinpermisos"))

        setup[:request].call(self)

        setup[:unauthorized].call(self)
      end
    end
  end
end
