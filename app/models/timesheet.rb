class Timesheet < ApplicationRecord
  serialize :worked_hours_per_shift, Array
  validates :personnel_number, :full_name, presence: { message: " не может быть пустым" }
end
