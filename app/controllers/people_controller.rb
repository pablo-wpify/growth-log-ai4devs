# «Personas» y ficha del líder (GL-05). Solo lectura. Todo registro se lee
# por el alcance de PersonPolicy (GL-03): una persona fuera del alcance no se
# encuentra y responde el mismo 404 que una inexistente.
#
# Las lecturas de entradas (GL-07: resumen, cronología y conteo) parten
# siempre del alcance de entradas, que solo contiene las de la cuenta, y
# nunca del modelo. verify_policy_scoped ya se cumple con el alcance de
# personas y no detectaría una consulta sin alcance: la protección es esta
# forma de consulta y sus pruebas (mutaciones M1 a M4 del diseño de GL-07).
class PeopleController < ApplicationController
  def index
    authorize Person
    @people = policy_scope(Person).order(:name, :id)
    # 1.15 parcial: entradas propias listas por persona, en una sola consulta.
    @ready_counts = policy_scope(FeedbackEntry).ready.where(person: @people).group(:person_id).count
  end

  def show
    @person = policy_scope(Person).find(params[:id])
    authorize @person
    entries = policy_scope(FeedbackEntry).where(person: @person)
    @summary = FeedbackSummary.new(entries.ready.group(:dimension, :signal).count)
    # Cronología (P-10): fecha del hecho ascendente; en empate, creación e id.
    @timeline = entries.order(occurred_on: :asc, created_at: :asc, id: :asc)
  end
end
