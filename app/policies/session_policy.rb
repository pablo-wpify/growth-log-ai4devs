# Cierre de la propia sesión (GL-03). Cualquier cuenta identificada puede
# cerrar la sesión con la que hace la petición.
class SessionPolicy < ApplicationPolicy
  def destroy?
    user.present?
  end
end
