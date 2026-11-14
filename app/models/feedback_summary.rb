# Resumen por dimensión de las entradas listas (GL-07; 4.1 con el ajuste de
# P-2). Recibe los conteos ya agrupados por dimensión y señal, calculados
# sobre el alcance de entradas listas: no consulta la base. Las filas siguen
# el orden de la lista de P-1 y omiten las dimensiones sin datos.
class FeedbackSummary
  Row = Data.define(:dimension, :label, :positive, :improvement, :neutral) do
    def total = positive + improvement + neutral
  end

  def initialize(counts)
    @counts = counts
  end

  def rows
    @rows ||= FeedbackEntry::DIMENSIONS.filter_map do |dimension, label|
      row = Row.new(dimension:, label:, positive: count(dimension, "positive"),
                    improvement: count(dimension, "improvement"), neutral: count(dimension, "neutral"))
      row if row.total.positive?
    end
  end

  def empty? = rows.empty?

  private
    def count(dimension, signal)
      @counts.fetch([ dimension, signal ], 0)
    end
end
