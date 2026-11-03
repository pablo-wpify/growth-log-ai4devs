class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization

  # Autorización (GL-03, P-5). Las verificaciones detectan en las pruebas una
  # acción que termina sin decisión de autorización o que no usó el alcance;
  # no prueban que la regla sea correcta. Las excepciones se declaran por
  # acción (spec/authorization/exceptions_spec.rb).
  after_action :verify_authorized
  after_action :verify_policy_scoped

  # Un acceso denegado responde igual que un recurso inexistente.
  rescue_from Pundit::NotAuthorizedError, ActiveRecord::RecordNotFound, with: :render_not_found

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private
    def pundit_user
      Current.user
    end

    def render_not_found
      render file: Rails.public_path.join("404.html"), status: :not_found, layout: false, content_type: "text/html"
    end
end
