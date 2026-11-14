# Entradas de feedback (GL-06). La base garantiza los datos obligatorios, las
# listas fijas de señales (P-2) y dimensiones (P-1), el rango de la confianza
# y que una entrada lista tenga dimensión y señal (P-3). Sin borrado en
# cascada: ni la cuenta autora ni la persona se borran con entradas (D5).
class CreateFeedbackEntries < ActiveRecord::Migration[8.1]
  SIGNALS = %w[positive improvement neutral].freeze
  DIMENSIONS = %w[delivery technical_quality teamwork communication initiative].freeze

  def change
    create_table :feedback_entries do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :person, null: false, foreign_key: true, index: false
      t.string :status, null: false, default: "draft"
      t.date :occurred_on, null: false
      t.text :context, null: false
      t.string :signal
      t.string :dimension
      t.text :evidence
      t.text :impact
      t.integer :confidence

      t.timestamps
    end

    add_index :feedback_entries, %i[person_id author_id]

    add_check_constraint :feedback_entries, "status IN ('draft', 'ready')",
      name: "feedback_entries_status_allowed"
    add_check_constraint :feedback_entries, "btrim(context) <> ''",
      name: "feedback_entries_context_present"
    add_check_constraint :feedback_entries, "signal IS NULL OR signal IN (#{quoted(SIGNALS)})",
      name: "feedback_entries_signal_allowed"
    add_check_constraint :feedback_entries, "dimension IS NULL OR dimension IN (#{quoted(DIMENSIONS)})",
      name: "feedback_entries_dimension_allowed"
    add_check_constraint :feedback_entries, "confidence IS NULL OR confidence BETWEEN 1 AND 5",
      name: "feedback_entries_confidence_range"
    add_check_constraint :feedback_entries,
      "status <> 'ready' OR (signal IS NOT NULL AND dimension IS NOT NULL)",
      name: "feedback_entries_ready_complete"
  end

  private
    def quoted(values)
      values.map { |value| "'#{value}'" }.join(", ")
    end
end
