class Timesheet < ApplicationRecord
  #validates :personnel_number, :full_name, presence: { message: " не может быть пустым" }

  has_many :worked_hours, dependent: :destroy

  accepts_nested_attributes_for :worked_hours
end