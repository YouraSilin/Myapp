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

ActiveRecord::Schema[7.0].define(version: 2022_10_20_094847) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "phones", force: :cascade do |t|
    t.string "number"
    t.string "name"
    t.string "colour"
    t.string "position"
    t.string "department"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "samples", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "timesheets", force: :cascade do |t|
    t.string "unit"
    t.string "subdivision_code"
    t.string "personnel_number"
    t.string "employment_official_date"
    t.string "employment_fact_date"
    t.string "full_name"
    t.string "position"
    t.text "worked_hours_per_shift"
    t.string "note"
    t.string "worked_shifts_total"
    t.string "worked_hours_total"
    t.string "worked_hours_per_day"
    t.string "worked_hours_per_night"
    t.string "check_formula"
    t.string "absences_total"
    t.string "absences_by_request"
    t.string "absences_by_certificate"
    t.string "absences_by_sick_leave"
    t.string "vacation_days_total"
    t.string "absences_by_permission"
    t.string "absences_with_working_out"
    t.string "absences_by_permission_vacation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "colour", default: "FFFFFF"
  end

  create_table "worked_hours", force: :cascade do |t|
    t.bigint "timesheet_id", null: false
    t.integer "day_of_month"
    t.float "hours"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["timesheet_id"], name: "index_worked_hours_on_timesheet_id"
  end

  add_foreign_key "worked_hours", "timesheets"
end
