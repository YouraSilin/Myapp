class CreateWorkedHours < ActiveRecord::Migration[7.0]
  def change
    create_table :worked_hours do |t|
      t.references :timesheet, null: false, foreign_key: true
      t.integer :day_of_month
      t.float :hours
      t.string :note
      t.string :fill
      t.timestamps
    end
  end
end