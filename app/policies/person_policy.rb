# Acceso de un líder a una persona (GL-03; PP-2, P-7, P-9). La regla vive en
# el alcance: personas activas con una asignación activa de la cuenta. El rol
# de administrador no interviene. La lectura de las entradas propias no
# depende de esta regla (PP-9, AM-1): la define la política de entradas.
class PersonPolicy < ApplicationPolicy
  def show?
    Scope.new(user, Person.all).resolve.exists?(record.id)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none unless user

      scope.active.where(id: Assignment.active.where(leader: user).select(:person_id))
    end
  end
end
