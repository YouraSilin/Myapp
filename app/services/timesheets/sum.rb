module Timesheets
  class Sum
    def self.call(first_timesheet, second_timesheet)
      worked_hours = (first_timesheet.worked_hours + second_timesheet.worked_hours)
        .group_by(&:day_of_month).map do |day_of_month, worked_hours|
        hours = worked_hours.map(&:hours).compact
        fills = worked_hours.map(&:fill)
        note = hours.any? ? '' : worked_hours.map(&:note).compact.first

        WorkedHour.new(
          day_of_month: day_of_month,
          hours: (hours.sum if hours.any?),
          fill: ( if hours.sum > 11 then 'FF0000' elsif fills.first.presence != fills.second && hours.first != nil && hours.second != nil then 'FF0000' else fills.first.presence || fills.second end ),
          note: note
        )
      end

      Timesheet.new(
        unit: first_timesheet.unit,
        subdivision_code: first_timesheet.subdivision_code,
        personnel_number: first_timesheet.personnel_number,
        employment_official_date: first_timesheet.employment_official_date.presence || second_timesheet.employment_official_date,
        employment_fact_date: first_timesheet.employment_fact_date.presence || second_timesheet.employment_fact_date,
        full_name: first_timesheet.full_name,
        position: first_timesheet.position,
        worked_hours: worked_hours
      ).tap { Timesheets::Recalculate.new(_1).call(save: :false) }
    end
  end
end

