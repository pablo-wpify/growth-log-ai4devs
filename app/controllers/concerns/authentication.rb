# Identifica a la persona en cada petición (GL-02). No decide permisos sobre
# recursos: eso corresponde a las políticas de GL-03.
module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private
    def authenticated?
      resume_session
    end

    def require_authentication
      resume_session || request_authentication
    end

    def resume_session
      Current.session ||= find_valid_session_by_cookie
    end

    # Comprueba en el servidor los dos vencimientos y la cuenta activa. Una
    # sesión que no los cumple se elimina y la petición queda sin sesión.
    def find_valid_session_by_cookie
      session_id = cookies.signed[:session_id]
      return unless session_id

      session = Session.includes(:user).find_by(id: session_id)
      now = Time.current

      if session.nil? || session.expired?(at: now) || !session.user.active?
        session&.destroy
        cookies.delete(:session_id)
        return
      end

      session.record_activity!(at: now)
      session
    end

    def request_authentication
      # Solo se recuerda la URL de peticiones idempotentes (GET o HEAD).
      session[:return_to_after_authenticating] = request.url if request.get? || request.head?
      redirect_to new_session_path
    end

    def after_authentication_url
      session.delete(:return_to_after_authenticating) || root_url
    end

    def start_new_session_for(user)
      return_to = session[:return_to_after_authenticating]
      reset_session # descarta la sesión anónima previa (fijación de sesión)
      session[:return_to_after_authenticating] = return_to if return_to

      # Las sesiones vencidas que el servidor ya no va a ver se borran aquí.
      user.sessions.expired.delete_all
      user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |new_session|
        Current.session = new_session
        cookies.signed[:session_id] = {
          value: new_session.id,
          expires: new_session.expires_at,
          httponly: true,
          same_site: :lax,
          secure: request.ssl?
        }
      end
    end

    def terminate_session
      Current.session&.destroy
      Current.session = nil
      cookies.delete(:session_id)
      reset_session
    end
end
