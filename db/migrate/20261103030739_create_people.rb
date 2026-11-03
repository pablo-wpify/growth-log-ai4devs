# Personas acompañadas (GL-03). Sin interfaz de administración en este
# cambio; `active` es independiente de asignaciones y cuentas (P-9).
class CreatePeople < ActiveRecord::Migration[8.1]
  def change
    create_table :people do |t|
      t.string :name, null: false
      t.string :role
      t.string :team
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
