require "rails_helper"

# Recorre todas las rutas de la aplicación sin sesión (GL-02). Fuera de las
# excepciones declaradas, cada ruta tiene que redirigir al inicio de sesión
# antes de ejecutar su acción y sin efectos en la base.
RSpec.describe "Rutas protegidas por defecto", type: :request do
  PUBLIC_ROUTES = [
    [ "GET", "/up" ],
    [ "GET", "/session/new" ],
    [ "POST", "/session" ]
  ].freeze

  def app_routes
    Rails.application.routes.routes.map do |route|
      verb = route.verb.presence || "GET"
      path = route.path.spec.to_s.sub("(.:format)", "").gsub(/:\w+/, "1").gsub(/\*\w+/, "x")
      [ verb, path, route ]
    end
  end

  def database_snapshot
    [ User.count, Session.count, LoginAttemptCounter.count ]
  end

  it "declara exactamente las rutas esperadas" do
    expect(app_routes.map { |verb, path, _| [ verb, path ] }).to contain_exactly(
      [ "GET", "/up" ],
      [ "GET", "/session/new" ],
      [ "POST", "/session" ],
      [ "DELETE", "/session" ],
      [ "GET", "/" ]
    )
  end

  it "no ofrece registro público ni recuperación de contraseña" do
    paths = app_routes.map { |_, path, _| path }

    expect(paths.grep(%r{password|registr|sign_?up|users/new|account}i)).to be_empty
  end

  it "responde sin sesión solo en las excepciones declaradas" do
    expect(app_routes.map { |verb, path, _| [ verb, path ] }).to include(*PUBLIC_ROUTES)

    get "/up"
    expect(response).to have_http_status(:ok)

    get "/session/new"
    expect(response).to have_http_status(:ok)
  end

  it "redirige al inicio de sesión antes de ejecutar cualquier otra acción y sin efectos" do
    create_user # una cuenta existente, para detectar cambios en la base

    app_routes.each do |verb, path, route|
      next if PUBLIC_ROUTES.include?([ verb, path ])

      controller_name = route.defaults[:controller]
      action = route.defaults[:action]

      if controller_name && action
        controller_class = "#{controller_name.camelize}Controller".constantize
        allow_any_instance_of(controller_class).to receive(action) do
          raise "#{verb} #{path} ejecutó #{controller_class}##{action} sin sesión"
        end
      end

      before = database_snapshot
      process verb.downcase.to_sym, path

      expect(response).to redirect_to(new_session_path), "#{verb} #{path} respondió #{response.status} sin sesión"
      expect(database_snapshot).to eq(before), "#{verb} #{path} modificó la base sin sesión"
    end
  end
end
