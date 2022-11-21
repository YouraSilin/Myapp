module Timesheets
  class Sum
    def self.call(first_timesheet, second_timesheet)
      worked_hours = (first_timesheet.worked_hours + second_timesheet.worked_hours)
        .group_by(&:day_of_month).map do |day_of_month, worked_hours|
        hours = worked_hours.map(&:hours).compact
        note = hours.any? ? '' : worked_hours.map(&:note).compact.first

        WorkedHour.new(
          day_of_month: day_of_month,
          hours: (hours.sum if hours.any?),
          fill: ('FF0000' if hours.sum > 11 ),
          note: note
        )
      end

      Timesheet.new(
        subdivision_code: first_timesheet.subdivision_code,
        personnel_number: first_timesheet.personnel_number,
        employment_official_date: first_timesheet.employment_official_date,
        employment_fact_date: first_timesheet.employment_fact_date,
        full_name: first_timesheet.full_name,
        worked_hours: worked_hours
      ).tap { Timesheets::Recalculate.new(_1).call(save: :false) }
    end
  end
end

