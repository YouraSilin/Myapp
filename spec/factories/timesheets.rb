FactoryBot.define do
  factory :timesheet do
    unit { 'кф' }
    subdivision_code { '2' }
    personnel_number { '177' }
    employment_official_date { "2020-11-16" }
    employment_fact_date { "2020-11-16" }
    full_name { 'TestName' }
    position { 'слесарь' }
    worked_shifts_total { '12' }
    worked_hours_total { '96' }
    worked_hours_per_day { '0' }
    worked_hours_per_night { '0' }
    check_formula { '0' }
    absences_total { '0' }
    absences_by_request { '0' }
    absences_by_certificate { '0' }
    absences_by_sick_leave { '0' }
    vacation_days_total { '0' }
    absences_by_permission { '0' }
    absences_with_working_out { '0' }
    absences_by_permission_vacation { '0' }
    colour { 'FFFFFF' }
  end
end
