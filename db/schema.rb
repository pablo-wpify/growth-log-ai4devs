# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_11_03_100707) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.bigint "leader_id", null: false
    t.bigint "person_id", null: false
    t.datetime "started_at", null: false
    t.datetime "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["leader_id", "person_id"], name: "index_assignments_one_active_per_pair", unique: true, where: "(ended_at IS NULL)"
    t.index ["leader_id"], name: "index_assignments_on_leader_id"
    t.index ["person_id"], name: "index_assignments_on_person_id"
    t.check_constraint "ended_at IS NULL OR ended_at >= started_at", name: "assignments_end_not_before_start"
  end

  create_table "login_attempt_counters", primary_key: "key", id: :string, force: :cascade do |t|
    t.integer "count", null: false
    t.datetime "expires_at", null: false
    t.index ["expires_at"], name: "index_login_attempt_counters_on_expires_at"
  end

  create_table "people", force: :cascade do |t|
    t.string "name", null: false
    t.string "role"
    t.string "team"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sample_data_records", force: :cascade do |t|
    t.string "key", null: false
    t.bigint "user_id"
    t.bigint "person_id"
    t.bigint "assignment_id"
    t.datetime "created_at", null: false
    t.index ["assignment_id"], name: "index_sample_data_records_on_assignment_id", unique: true
    t.index ["key"], name: "index_sample_data_records_on_key", unique: true
    t.index ["person_id"], name: "index_sample_data_records_on_person_id", unique: true
    t.index ["user_id"], name: "index_sample_data_records_on_user_id", unique: true
    t.check_constraint "num_nonnulls(user_id, person_id, assignment_id) = 1", name: "sample_data_records_exactly_one_reference"
    t.check_constraint "user_id IS NOT NULL AND key::text ~~ 'account:%'::text OR person_id IS NOT NULL AND key::text ~~ 'person:%'::text OR assignment_id IS NOT NULL AND key::text ~~ 'assignment:%'::text", name: "sample_data_records_key_matches_reference"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "last_active_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.boolean "admin", default: false, null: false
    t.datetime "deactivated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "assignments", "people"
  add_foreign_key "assignments", "users", column: "leader_id"
  add_foreign_key "sample_data_records", "assignments"
  add_foreign_key "sample_data_records", "people"
  add_foreign_key "sample_data_records", "users"
  add_foreign_key "sessions", "users"
end
