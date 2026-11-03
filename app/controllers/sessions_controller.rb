# Inicio y cierre de sesión (GL-02). Ante cualquier fallo responde igual:
# mismo estado y mismo mensaje, sin indicar qué dato falló.
class SessionsController < ApplicationController
  FAILURE_MESSAGE = "Correo o contraseña incorrectos.".freeze
  TOO_MANY_ATTEMPTS_MESSAGE = "Demasiados intentos. Probá de nuevo en unos minutos.".freeze

  allow_unauthenticated_access only: %i[ new create ]
  # Sin cuenta identificada no hay a quién autorizar. Excepción por acción:
  # una acción nueva queda sujeta a las verificaciones (GL-03).
  skip_after_action :verify_authorized, :verify_policy_scoped, only: %i[ new create ]

  # Por IP: 10 intentos totales (exitosos o fallidos) en una ventana fija de
  # 3 minutos. La clave usa el SHA-256 de la IP, no la IP en claro.
  rate_limit to: 10, within: 3.minutes, only: :create, name: "ip",
    by: -> { Digest::SHA256.hexdigest(request.remote_ip.to_s) },
    store: LoginAttemptStore.new,
    with: -> { render_too_many_attempts }

  # Por correo: reserva atómica antes de buscar la cuenta o comparar la
  # contraseña; sin lugar dentro del límite, 429 sin evaluar credenciales.
  before_action :reserve_email_attempt, only: :create

  def new
  end

  def create
    user = User.authenticate_by(email_address: params[:email_address].to_s, password: params[:password].to_s)

    if user&.active?
      email_throttle.reset!
      start_new_session_for user
      redirect_to after_authentication_url, status: :see_other
    else
      # El fallo ya quedó contado por la reserva de reserve_email_attempt.
      flash.now[:alert] = FAILURE_MESSAGE
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    authorize :session, :destroy?
    skip_policy_scope # no lee registros
    terminate_session
    redirect_to new_session_path, status: :see_other
  end

  private
    def email_throttle
      @email_throttle ||= EmailLoginThrottle.new(params[:email_address])
    end

    def reserve_email_attempt
      render_too_many_attempts unless email_throttle.reserve_attempt
    end

    def render_too_many_attempts
      flash.now[:alert] = TOO_MANY_ATTEMPTS_MESSAGE
      render :new, status: :too_many_requests
    end
end
