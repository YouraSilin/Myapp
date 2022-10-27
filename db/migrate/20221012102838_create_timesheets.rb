class CreateTimesheets < ActiveRecord::Migration[7.0]
  def change
    create_table :timesheets do |t|
      t.string :unit
      t.string :subdivision_code
      t.string :personnel_number
      t.string :employment_official_date
      t.string :employment_fact_date
      t.string :full_name
      t.string :position
      t.text :worked_hours_per_shift
      t.string :note
      t.float :worked_shifts_total
      t.float :worked_hours_total
      t.float :worked_hours_per_day
      t.float :worked_hours_per_night
      t.string :check_formula
      t.string :absences_total
      t.string :absences_by_request
      t.string :absences_by_certificate
      t.string :absences_by_sick_leave
      t.string :vacation_days_total
      t.string :absences_by_permission
      t.string :absences_with_working_out
      t.string :absences_by_permission_vacation

      t.timestamps
    end
  end
end
