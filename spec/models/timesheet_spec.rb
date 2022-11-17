require 'rails_helper'

RSpec.describe Timesheet do
  describe '+(other_timesheet)' do
    let!(:first_timesheet) { create(:timesheet, worked_hours: first_worked_hours) }
    let!(:second_timesheet) { create(:timesheet, worked_hours: second_worked_hours) }

    let(:first_worked_hours) do
      [
        build(:worked_hour, day_of_month: 1, hours: 8.0),
        build(:worked_hour, day_of_month: 2, hours: 3.0, fill: 'cccccc'),
        build(:worked_hour, day_of_month: 3, hours: nil, note: 'н'),
        build(:worked_hour, day_of_month: 4, hours: nil, note: 'ду')
      ]
    end

    let(:second_worked_hours) do
      [
        build(:worked_hour, day_of_month: 1, hours: 2.0),
        build(:worked_hour, day_of_month: 3, hours: 5, note: ''),
        build(:worked_hour, day_of_month: 4, hours: nil, note: 'ду')
      ]
    end

    it 'counts worked hours' do
      new_timesheet = first_timesheet + second_timesheet

      expect(first_timesheet.worked_hours.size).to eq(first_worked_hours.size)
      expect(second_timesheet.worked_hours.size).to eq(second_worked_hours.size)

      new_worked_hours = new_timesheet.worked_hours.map { _1.attributes.slice('hours', 'note', 'day_of_month', 'fill') }
      expect(new_worked_hours).to eq([
        {"day_of_month"=>1, "fill"=>nil, "hours"=>10.0, "note"=>""},
        {"day_of_month"=>2, "fill"=>nil, "hours"=>3.0, "note"=>""},
        {"day_of_month"=>3, "fill"=>nil, "hours"=>5.0, "note"=>""},
        {"day_of_month"=>4, "fill"=>nil, "hours"=>nil, "note"=>"ду"}
      ])

      expect(new_timesheet.worked_shifts_total).to eq(3.0)
      expect(new_timesheet.worked_hours_total).to eq(18.0)
      expect(new_timesheet.absences_total).to eq("0")
      expect(new_timesheet.absences_by_request).to eq("0")
      expect(new_timesheet.absences_by_certificate).to eq("0")
      expect(new_timesheet.absences_by_sick_leave).to eq("0")
      expect(new_timesheet.vacation_days_total).to eq("0")
      expect(new_timesheet.absences_by_permission).to eq("0")
      expect(new_timesheet.absences_with_working_out).to eq("0")
      expect(new_timesheet.absences_by_permission_vacation).to eq("0")
      expect(new_timesheet.worked_hours_per_day).to eq(0.0)
      expect(new_timesheet.worked_hours_per_night).to eq(18.0)
      expect(new_timesheet.check_formula).to eq("0")
    end
  end
end
