# Datos de la ficha de una persona (GL-07): resumen y cronología. Los usa la
# ficha y, en GL-15, el formulario completo cuando vuelve a mostrar la ficha
# con errores de validación. Las lecturas parten siempre del alcance de
# entradas, que solo contiene las de la cuenta, y nunca del modelo.
module PersonPage
  extend ActiveSupport::Concern

  private
    def load_person_page(person)
      entries = policy_scope(FeedbackEntry).where(person: person)
      @summary = FeedbackSummary.new(entries.ready.group(:dimension, :signal).count)
      # Cronología (P-10): fecha del hecho ascendente; en empate, creación e id.
      @timeline = entries.order(occurred_on: :asc, created_at: :asc, id: :asc)
    end
end
