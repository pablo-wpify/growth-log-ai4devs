# Página de inicio provisoria (GL-02, autorizada en GL-03). Cualquier cuenta
# identificada puede verla; que esté activa lo garantiza la autenticación.
# No da acceso a ningún recurso.
class HomePolicy < ApplicationPolicy
  def show?
    user.present?
  end
end
