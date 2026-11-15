# Marcas del conjunto demo de la instancia temporal (GL-10, P-31). Tabla
# propia, separada de sample_data_records (GL-08), para que la capacidad demo
# no cambie la de desarrollo. Identifican exclusivamente los registros que
# creó la tarea de datos demo; existe en todos los entornos y solo se llena en
# la instancia demo.
class CreateDemoDataRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :demo_data_records do |t|
      t.string :key, null: false
      t.references :user, foreign_key: true, index: { unique: true }
      t.references :person, foreign_key: true, index: { unique: true }
      t.references :assignment, foreign_key: true, index: { unique: true }
      t.references :feedback_entry, foreign_key: true, index: { unique: true }
      t.datetime :created_at, null: false
    end

    add_index :demo_data_records, :key, unique: true
    add_check_constraint :demo_data_records,
      "num_nonnulls(user_id, person_id, assignment_id, feedback_entry_id) = 1",
      name: "demo_data_records_exactly_one_reference"
    add_check_constraint :demo_data_records,
      "(user_id IS NOT NULL AND key LIKE 'demo:account:%') OR " \
      "(person_id IS NOT NULL AND key LIKE 'demo:person:%') OR " \
      "(assignment_id IS NOT NULL AND key LIKE 'demo:assignment:%') OR " \
      "(feedback_entry_id IS NOT NULL AND key LIKE 'demo:entry:%')",
      name: "demo_data_records_key_matches_reference"
  end
end
