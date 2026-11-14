# «Personas» y ficha del líder (GL-05). Solo lectura. Todo registro se lee
# por el alcance de PersonPolicy (GL-03): una persona fuera del alcance no se
# encuentra y responde el mismo 404 que una inexistente.
class PeopleController < ApplicationController
  def index
    authorize Person
    @people = policy_scope(Person).order(:name, :id)
  end

  def show
    @person = policy_scope(Person).find(params[:id])
    authorize @person
    # Sección «Tus entradas» (GL-06, P-21): siempre a través del alcance de
    # entradas, que solo contiene las de la cuenta. verify_policy_scoped ya
    # se cumple con la persona y no detectaría una consulta sin alcance: la
    # protección es esta forma de consulta y su prueba (mutación 4).
    @entries = policy_scope(FeedbackEntry).where(person: @person)
                                          .order(occurred_on: :desc, created_at: :desc, id: :desc)
  end
end
