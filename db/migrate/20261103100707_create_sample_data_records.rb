# Marcas del conjunto ficticio de desarrollo (GL-08, P-13). Identifican
# exclusivamente los registros que creó growth_log:datos_ficticios. Una
# referencia tipada por clase, con clave foránea, evita marcas huérfanas y
# referencias ambiguas; existe en todos los entornos y solo se llena en
# desarrollo.
class CreateSampleDataRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :sample_data_records do |t|
      t.string :key, null: false
      t.references :user, foreign_key: true, index: { unique: true }
      t.references :person, foreign_key: true, index: { unique: true }
      t.references :assignment, foreign_key: true, index: { unique: true }
      t.datetime :created_at, null: false
    end

    add_index :sample_data_records, :key, unique: true
    add_check_constraint :sample_data_records,
      "num_nonnulls(user_id, person_id, assignment_id) = 1",
      name: "sample_data_records_exactly_one_reference"
    add_check_constraint :sample_data_records,
      "(user_id IS NOT NULL AND key LIKE 'account:%') OR " \
      "(person_id IS NOT NULL AND key LIKE 'person:%') OR " \
      "(assignment_id IS NOT NULL AND key LIKE 'assignment:%')",
      name: "sample_data_records_key_matches_reference"
  end
end
