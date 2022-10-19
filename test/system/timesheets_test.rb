require "application_system_test_case"

class TimesheetsTest < ApplicationSystemTestCase
  setup do
    @timesheet = timesheets(:one)
  end

  test "visiting the index" do
    visit timesheets_url
    assert_selector "h1", text: "Timesheets"
  end

  test "should create timesheet" do
    visit timesheets_url
    click_on "New timesheet"

    fill_in "Absences by certificate", with: @timesheet.absences_by_certificate
    fill_in "Absences by permission", with: @timesheet.absences_by_permission
    fill_in "Absences by permission vacation", with: @timesheet.absences_by_permission_vacation
    fill_in "Absences by request", with: @timesheet.absences_by_request
    fill_in "Absences by sick leave", with: @timesheet.absences_by_sick_leave
    fill_in "Absences total", with: @timesheet.absences_total
    fill_in "Absences with working out", with: @timesheet.absences_with_working_out
    fill_in "Check formula", with: @timesheet.check_formula
    fill_in "Employment fact date", with: @timesheet.employment_fact_date
    fill_in "Employment official date", with: @timesheet.employment_official_date
    fill_in "Full name", with: @timesheet.full_name
    fill_in "Note", with: @timesheet.note
    fill_in "Personnel number", with: @timesheet.personnel_number
    fill_in "Position", with: @timesheet.position
    fill_in "Subdivision code", with: @timesheet.subdivision_code
    fill_in "Unit", with: @timesheet.unit
    fill_in "Vacation days total", with: @timesheet.vacation_days_total
    fill_in "Worked hours per day", with: @timesheet.worked_hours_per_day
    fill_in "Worked hours per night", with: @timesheet.worked_hours_per_night
    fill_in "Worked hours per shift", with: @timesheet.worked_hours_per_shift
    fill_in "Worked hours total", with: @timesheet.worked_hours_total
    fill_in "Worked shifts total", with: @timesheet.worked_shifts_total
    click_on "Create Timesheet"

    assert_text "Timesheet was successfully created"
    click_on "Back"
  end

  test "should update Timesheet" do
    visit timesheet_url(@timesheet)
    click_on "Edit this timesheet", match: :first

    fill_in "Absences by certificate", with: @timesheet.absences_by_certificate
    fill_in "Absences by permission", with: @timesheet.absences_by_permission
    fill_in "Absences by permission vacation", with: @timesheet.absences_by_permission_vacation
    fill_in "Absences by request", with: @timesheet.absences_by_request
    fill_in "Absences by sick leave", with: @timesheet.absences_by_sick_leave
    fill_in "Absences total", with: @timesheet.absences_total
    fill_in "Absences with working out", with: @timesheet.absences_with_working_out
    fill_in "Check formula", with: @timesheet.check_formula
    fill_in "Employment fact date", with: @timesheet.employment_fact_date
    fill_in "Employment official date", with: @timesheet.employment_official_date
    fill_in "Full name", with: @timesheet.full_name
    fill_in "Note", with: @timesheet.note
    fill_in "Personnel number", with: @timesheet.personnel_number
    fill_in "Position", with: @timesheet.position
    fill_in "Subdivision code", with: @timesheet.subdivision_code
    fill_in "Unit", with: @timesheet.unit
    fill_in "Vacation days total", with: @timesheet.vacation_days_total
    fill_in "Worked hours per day", with: @timesheet.worked_hours_per_day
    fill_in "Worked hours per night", with: @timesheet.worked_hours_per_night
    fill_in "Worked hours per shift", with: @timesheet.worked_hours_per_shift
    fill_in "Worked hours total", with: @timesheet.worked_hours_total
    fill_in "Worked shifts total", with: @timesheet.worked_shifts_total
    click_on "Update Timesheet"

    assert_text "Timesheet was successfully updated"
    click_on "Back"
  end

  test "should destroy Timesheet" do
    visit timesheet_url(@timesheet)
    click_on "Destroy this timesheet", match: :first

    assert_text "Timesheet was successfully destroyed"
  end
end
