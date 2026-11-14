# Acceso a las entradas de feedback (GL-06; P-7, P-9, P-20; PP-3, PP-4, PP-9).
# - Leer: ser el autor. No depende de la asignación ni del estado de la
#   persona: el autor conserva la lectura de sus entradas, también de los
#   borradores (PP-9, AM-1).
# - Escribir (crear, editar, marcar como lista): ser el autor y que la persona
#   esté en el alcance de personas de GL-03, que ya exige asignación activa y
#   persona activa.
# El rol de administrador no aparece en ninguna condición (PP-8). Compartir
# no existe en este cambio: nadie lee entradas ajenas.
class FeedbackEntryPolicy < ApplicationPolicy
  def show? = author?
  def create? = author? && writable_person?
  def update? = author? && writable_person?
  def mark_ready? = update?

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none unless user

      scope.where(author: user)
    end
  end

  private
    def author?
      user.present? && record.author_id == user.id
    end

    def writable_person?
      PersonPolicy::Scope.new(user, Person.all).resolve.exists?(record.person_id)
    end
end
