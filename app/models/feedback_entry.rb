# Entrada de feedback de una cuenta sobre una persona (GL-06). Es siempre
# privada de su autor: «lista» no cambia quién la lee (PP-3, PP-4). La base
# garantiza las restricciones; estas validaciones existen para mostrar el
# error en español antes de llegar a ella.
class FeedbackEntry < ApplicationRecord
  # P-1 (aprobada el 12/11/2026): lista fija; cambiarla exige una migración.
  DIMENSIONS = {
    "delivery" => "Entrega",
    "technical_quality" => "Calidad técnica",
    "teamwork" => "Trabajo en equipo",
    "communication" => "Comunicación",
    "initiative" => "Iniciativa"
  }.freeze

  # P-2 (aprobada el 12/11/2026).
  SIGNALS = {
    "positive" => "Positivo",
    "improvement" => "A mejorar",
    "neutral" => "Neutral"
  }.freeze

  READY_FIELDS = { dimension: "dimensión", signal: "señal" }.freeze

  belongs_to :author, class_name: "User"
  belongs_to :person

  enum :status, { draft: "draft", ready: "ready" }, default: "draft", validate: true

  # «Sin indicar» llega como valor vacío y se guarda como ausencia de dato.
  normalizes :signal, :dimension, :evidence, :impact, with: ->(value) { value.presence }

  validates :occurred_on, presence: { message: "Indicá la fecha del hecho." }
  validates :context, presence: { message: "Contá qué pasó." }
  validates :signal, inclusion: { in: SIGNALS.keys, message: "Elegí una señal de la lista." }, allow_nil: true
  validates :dimension, inclusion: { in: DIMENSIONS.keys, message: "Elegí una dimensión de la lista." }, allow_nil: true
  validates :confidence, numericality: { only_integer: true, in: 1..5, message: "La confianza va de 1 a 5." }, allow_nil: true
  validate :ready_entries_complete, if: :ready?

  def dimension_label = DIMENSIONS[dimension]
  def signal_label = SIGNALS[signal]

  # Campos que faltan para que la entrada pueda estar lista (P-3).
  def missing_for_ready
    READY_FIELDS.keys.select { |field| public_send(field).blank? }
  end

  # Pasa un borrador a lista. Si falta algo, no modifica el registro, deja el
  # motivo en errors[:base] y devuelve false.
  def mark_ready
    missing = missing_for_ready
    if missing.any?
      errors.add(:base, "Para marcarla como lista falta: #{missing.map { |field| READY_FIELDS[field] }.to_sentence(two_words_connector: ' y ', last_word_connector: ' y ')}.")
      return false
    end

    update(status: "ready")
  end

  private
    def ready_entries_complete
      missing_for_ready.each do |field|
        errors.add(field, "Para que la entrada esté lista falta la #{READY_FIELDS[field]}.")
      end
    end
end
