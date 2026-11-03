# Asignaciones entre líderes y personas (GL-03). Una sola activa por par
# líder y persona (P-8), sin límite de líderes por persona; reasignar crea
# una fila nueva.
class CreateAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :assignments do |t|
      t.references :leader, null: false, foreign_key: { to_table: :users }, index: false
      t.references :person, null: false, foreign_key: true
      t.datetime :started_at, null: false
      t.datetime :ended_at

      t.timestamps
    end

    add_index :assignments, %i[leader_id person_id], unique: true,
      where: "ended_at IS NULL", name: "index_assignments_one_active_per_pair"
    add_index :assignments, :leader_id
    add_check_constraint :assignments, "ended_at IS NULL OR ended_at >= started_at",
      name: "assignments_end_not_before_start"
  end
end
