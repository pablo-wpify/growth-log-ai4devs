# Sesión guardada en el servidor (GL-02, D-GL02-2). Los vencimientos se
# calculan con estos datos, no con el vencimiento de la cookie.
class Session < ApplicationRecord
  IDLE_TIMEOUT = 2.hours
  ABSOLUTE_TIMEOUT = 12.hours
  ACTIVITY_REFRESH_INTERVAL = 5.minutes

  belongs_to :user

  before_create { self.last_active_at ||= created_at || Time.current }

  scope :expired, ->(at: Time.current) {
    where(last_active_at: ..(at - IDLE_TIMEOUT)).or(where(created_at: ..(at - ABSOLUTE_TIMEOUT)))
  }

  def expired?(at: Time.current)
    last_active_at <= at - IDLE_TIMEOUT || created_at <= at - ABSOLUTE_TIMEOUT
  end

  def expires_at
    created_at + ABSOLUTE_TIMEOUT
  end

  # Un único UPDATE, sin callbacks ni cambio de updated_at, como mucho una vez
  # cada ACTIVITY_REFRESH_INTERVAL. Por esa granularidad, la inactividad puede
  # vencer hasta 5 minutos antes de las 2 horas exactas.
  def record_activity!(at: Time.current)
    update_column(:last_active_at, at) if last_active_at <= at - ACTIVITY_REFRESH_INTERVAL
  end
end
