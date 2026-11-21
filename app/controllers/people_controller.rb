# «Personas» y ficha del líder (GL-05). Solo lectura. Todo registro se lee
# por el alcance de PersonPolicy (GL-03): una persona fuera del alcance no se
# encuentra y responde el mismo 404 que una inexistente.
#
# Las lecturas de entradas (GL-07: resumen, cronología y conteo; GL-14:
# conteos de listas y borradores, fecha del último hecho y la decisión de
# mostrar «Registrar la primera») parten siempre del alcance de entradas,
# que solo contiene las de la cuenta, y nunca del modelo.
# verify_policy_scoped ya se cumple con el alcance de personas y no
# detectaría una consulta sin alcance: la protección es esta forma de
# consulta y sus pruebas (mutaciones M1 a M4 del diseño de GL-07).
class PeopleController < ApplicationController
  include PersonPage

  def index
    authorize Person
    @people = policy_scope(Person).order(:name, :id).to_a
    @entry_stats = entry_stats_for(@people)
  end

  def show
    @person = policy_scope(Person).find(params[:id])
    authorize @person
    load_person_page(@person)
  end

  private
    EntryStats = Data.define(:ready, :drafts, :last_fact_on) do
      def none? = ready.zero? && drafts.zero?
    end
    NO_ENTRIES = EntryStats.new(ready: 0, drafts: 0, last_fact_on: nil)

    # GL-14 (P-41, P-42; 1.15 parcial): una sola consulta agregada sobre el
    # alcance de entradas. Las listas son las visibles para la cuenta y los
    # borradores, los propios: hoy el alcance solo tiene las de la cuenta y
    # un borrador nunca se comparte (3.9). Una persona sin filas no tiene
    # entradas de la cuenta, y eso decide «Registrar la primera».
    def entry_stats_for(people)
      rows = policy_scope(FeedbackEntry).where(person_id: people.map(&:id)).group(:person_id).pluck(
        :person_id,
        Arel.sql("COUNT(*) FILTER (WHERE status = 'ready')"),
        Arel.sql("COUNT(*) FILTER (WHERE status = 'draft')"),
        Arel.sql("MAX(occurred_on) FILTER (WHERE status = 'ready')")
      )
      stats = rows.to_h { |person_id, ready, drafts, last| [ person_id, EntryStats.new(ready:, drafts:, last_fact_on: last) ] }
      stats.default = NO_ENTRIES
      stats
    end
end
