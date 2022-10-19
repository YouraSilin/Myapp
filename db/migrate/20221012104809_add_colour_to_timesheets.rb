class AddColourToTimesheets < ActiveRecord::Migration[7.0]
  def change
    add_column :timesheets, :colour, :string, :default => "FFFFFF"
  end
end
