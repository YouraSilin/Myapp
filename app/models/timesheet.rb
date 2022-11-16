class Timesheet < ApplicationRecord
  #validates :personnel_number, :full_name, presence: { message: " не может быть пустым" }

  def +(new_timesheet)
    self.worked_hours += new_timesheet.worked_hours
    Timesheets::Recalculate.new(self).call(save: false)
  
    self
  end

  has_many :worked_hours, dependent: :destroy

  accepts_nested_attributes_for :worked_hours
end