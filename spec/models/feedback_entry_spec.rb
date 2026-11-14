require "rails_helper"

# Entradas de feedback (GL-06; spec feedback-entries). La base es la
# garantía: cada restricción se prueba insertando la fila directamente, sin
# pasar por las validaciones del modelo. Las validaciones existen para dar el
# mensaje en español y se prueban aparte.
RSpec.describe FeedbackEntry, type: :model do
  let(:author) { create_user(email_address: "luis.lider@example.test") }
  let(:person) { create_person(name: "Ada Ejemplo") }

  def valid_row(**overrides)
    {
      author_id: author.id, person_id: person.id, status: "draft",
      occurred_on: Date.new(2026, 11, 12), context: "Resolvió el incidente del lunes"
    }.merge(overrides)
  end

  # Inserta sin validaciones ni conversión de tipos del modelo, para que el
  # rechazo, si ocurre, venga de la base. Cada sentencia va en su propio
  # savepoint: un rechazo no aborta la transacción del ejemplo.
  def insert_row(**overrides)
    row = valid_row(**overrides).merge(created_at: Time.current, updated_at: Time.current)
    connection = FeedbackEntry.connection
    columns = row.keys.map { |column| connection.quote_column_name(column) }.join(", ")
    values = row.values.map { |value| connection.quote(value) }.join(", ")
    in_savepoint { connection.execute("INSERT INTO feedback_entries (#{columns}) VALUES (#{values})") }
  end

  def in_savepoint(&block)
    FeedbackEntry.transaction(requires_new: true, &block)
  end

  describe "restricciones de la base" do
    it "acepta una fila válida (control)" do
      expect { insert_row }.to change(FeedbackEntry, :count).by(1)
    end

    it "rechaza una entrada sin autor" do
      expect { insert_row(author_id: nil) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "rechaza una entrada sin persona" do
      expect { insert_row(person_id: nil) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "rechaza una entrada sin fecha del hecho" do
      expect { insert_row(occurred_on: nil) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "rechaza una entrada sin contexto" do
      expect { insert_row(context: nil) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "rechaza un contexto vacío o solo con espacios" do
      expect { insert_row(context: "") }.to raise_error(ActiveRecord::CheckViolation)
      expect { insert_row(context: "   ") }.to raise_error(ActiveRecord::CheckViolation)
    end

    it "rechaza un estado distinto de draft o ready" do
      expect { insert_row(status: "shared") }.to raise_error(ActiveRecord::CheckViolation)
    end

    it "rechaza una señal fuera de la lista" do
      expect { insert_row(signal: "mejora") }.to raise_error(ActiveRecord::CheckViolation)
    end

    it "rechaza una dimensión fuera de la lista" do
      expect { insert_row(dimension: "claridad") }.to raise_error(ActiveRecord::CheckViolation)
    end

    it "rechaza una confianza fuera de 1 a 5" do
      expect { insert_row(confidence: 0) }.to raise_error(ActiveRecord::CheckViolation)
      expect { insert_row(confidence: 6) }.to raise_error(ActiveRecord::CheckViolation)
    end

    it "acepta los valores de las listas y la confianza en el rango" do
      FeedbackEntry::DIMENSIONS.each_key { |value| insert_row(dimension: value) }
      FeedbackEntry::SIGNALS.each_key { |value| insert_row(signal: value) }
      (1..5).each { |value| insert_row(confidence: value) }

      expect(FeedbackEntry.count).to eq(5 + 3 + 5)
    end

    it "acepta un borrador sin señal ni dimensión (P-3)" do
      expect { insert_row(signal: nil, dimension: nil) }.to change(FeedbackEntry, :count).by(1)
    end

    it "rechaza una entrada lista sin señal (P-3)" do
      expect {
        insert_row(status: "ready", dimension: "teamwork", signal: nil)
      }.to raise_error(ActiveRecord::CheckViolation)
    end

    it "rechaza una entrada lista sin dimensión (P-3)" do
      expect {
        insert_row(status: "ready", dimension: nil, signal: "positive")
      }.to raise_error(ActiveRecord::CheckViolation)
    end

    it "acepta una entrada lista con dimensión y señal" do
      expect {
        insert_row(status: "ready", dimension: "teamwork", signal: "positive")
      }.to change(FeedbackEntry, :count).by(1)
    end

    it "no permite borrar la cuenta autora ni la persona de una entrada" do
      insert_row

      expect { in_savepoint { author.delete } }.to raise_error(ActiveRecord::InvalidForeignKey)
      expect { in_savepoint { person.delete } }.to raise_error(ActiveRecord::InvalidForeignKey)
    end
  end

  describe "listas fijas y etiquetas" do
    it "tiene las cinco dimensiones de P-1 con sus etiquetas" do
      expect(FeedbackEntry::DIMENSIONS).to eq(
        "delivery" => "Entrega",
        "technical_quality" => "Calidad técnica",
        "teamwork" => "Trabajo en equipo",
        "communication" => "Comunicación",
        "initiative" => "Iniciativa"
      )
    end

    it "tiene las tres señales de P-2 con sus etiquetas" do
      expect(FeedbackEntry::SIGNALS).to eq(
        "positive" => "Positivo",
        "improvement" => "A mejorar",
        "neutral" => "Neutral"
      )
    end

    it "muestra la etiqueta de la dimensión y de la señal guardadas" do
      entry = FeedbackEntry.create!(valid_row(dimension: "teamwork", signal: "improvement"))

      expect(entry.dimension_label).to eq("Trabajo en equipo")
      expect(entry.signal_label).to eq("A mejorar")
    end
  end

  describe "validaciones del modelo" do
    def build(**overrides)
      FeedbackEntry.new(valid_row(**overrides))
    end

    it "un borrador nuevo es borrador por defecto" do
      expect(FeedbackEntry.new).to be_draft
    end

    it "informa que falta el contexto sin guardar" do
      entry = build(context: "   ")

      expect(entry.save).to be(false)
      expect(entry.errors[:context]).to include("Contá qué pasó.")
      expect(FeedbackEntry.count).to eq(0)
    end

    it "informa que falta la fecha del hecho sin guardar" do
      entry = build(occurred_on: nil)

      expect(entry.save).to be(false)
      expect(entry.errors[:occurred_on]).to include("Indicá la fecha del hecho.")
    end

    it "rechaza una señal, una dimensión o una confianza fuera de las listas" do
      entry = build(signal: "mejora", dimension: "claridad", confidence: 6)

      expect(entry).not_to be_valid
      expect(entry.errors.attribute_names).to include(:signal, :dimension, :confidence)
    end

    it "rechaza un estado desconocido sin lanzar una excepción" do
      entry = build(status: "shared")

      expect(entry).not_to be_valid
      expect(entry.errors.attribute_names).to include(:status)
    end

    it "convierte la opción «Sin indicar» (valor vacío) en ausencia de dato" do
      entry = build(signal: "", dimension: "", confidence: "", evidence: "", impact: "")

      expect(entry).to be_valid
      expect([ entry.signal, entry.dimension, entry.confidence, entry.evidence, entry.impact ]).to all(be_nil)
    end

    it "no deja guardar una entrada lista sin señal o sin dimensión" do
      entry = FeedbackEntry.create!(valid_row(status: "ready", dimension: "teamwork", signal: "positive"))

      expect(entry.update(signal: nil)).to be(false)
      expect(entry.errors[:signal]).to include("Para que la entrada esté lista falta la señal.")
      expect(entry.reload.signal).to eq("positive")
    end
  end

  describe "#mark_ready" do
    it "pasa a lista un borrador con dimensión y señal" do
      entry = FeedbackEntry.create!(valid_row(dimension: "delivery", signal: "positive"))

      expect(entry.mark_ready).to be(true)
      expect(entry.reload).to be_ready
    end

    it "con un borrador incompleto devuelve falso, indica qué falta y no lo modifica" do
      entry = FeedbackEntry.create!(valid_row)
      updated_at = entry.updated_at

      expect(entry.mark_ready).to be(false)
      expect(entry.missing_for_ready).to eq(%i[dimension signal])
      expect(entry.errors[:base]).to include("Para marcarla como lista falta: dimensión y señal.")
      expect(entry.reload).to be_draft
      expect(entry.updated_at).to eq(updated_at)
    end

    it "indica solo la señal cuando la dimensión está" do
      entry = FeedbackEntry.create!(valid_row(dimension: "delivery"))

      expect(entry.mark_ready).to be(false)
      expect(entry.errors[:base]).to include("Para marcarla como lista falta: señal.")
      expect(entry.reload).to be_draft
    end
  end

  describe "asociaciones" do
    it "la persona y la cuenta autora conocen sus entradas y no se borran con ellas" do
      entry = FeedbackEntry.create!(valid_row)

      expect(person.feedback_entries).to contain_exactly(entry)
      expect(author.authored_feedback_entries).to contain_exactly(entry)
      expect { person.destroy }.to raise_error(ActiveRecord::DeleteRestrictionError)
      expect { author.destroy }.to raise_error(ActiveRecord::DeleteRestrictionError)
    end
  end
end
