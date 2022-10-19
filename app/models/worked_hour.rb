class WorkedHour < ApplicationRecord
  belongs_to :timesheet

  def display
    return note if note

    if hours.to_i == hours
      hours.to_i
    else
      hours
    end
  end
end
