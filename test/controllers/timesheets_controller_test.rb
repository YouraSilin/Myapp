require "test_helper"

class TimesheetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @timesheet = timesheets(:one)
  end

  test "should get index" do
    get timesheets_url
    assert_response :success
  end

  test "should get new" do
    get new_timesheet_url
    assert_response :success
  end

  test "should create timesheet" do
    assert_difference("Timesheet.count") do
      post timesheets_url, params: { timesheet: { absences_by_certificate: @timesheet.absences_by_certificate, absences_by_permission: @timesheet.absences_by_permission, absences_by_permission_vacation: @timesheet.absences_by_permission_vacation, absences_by_request: @timesheet.absences_by_request, absences_by_sick_leave: @timesheet.absences_by_sick_leave, absences_total: @timesheet.absences_total, absences_with_working_out: @timesheet.absences_with_working_out, check_formula: @timesheet.check_formula, employment_fact_date: @timesheet.employment_fact_date, employment_official_date: @timesheet.employment_official_date, full_name: @timesheet.full_name, note: @timesheet.note, personnel_number: @timesheet.personnel_number, position: @timesheet.position, subdivision_code: @timesheet.subdivision_code, unit: @timesheet.unit, vacation_days_total: @timesheet.vacation_days_total, worked_hours_per_day: @timesheet.worked_hours_per_day, worked_hours_per_night: @timesheet.worked_hours_per_night, worked_hours_per_shift: @timesheet.worked_hours_per_shift, worked_hours_total: @timesheet.worked_hours_total, worked_shifts_total: @timesheet.worked_shifts_total } }
    end

    assert_redirected_to timesheet_url(Timesheet.last)
  end

  test "should show timesheet" do
    get timesheet_url(@timesheet)
    assert_response :success
  end

  test "should get edit" do
    get edit_timesheet_url(@timesheet)
    assert_response :success
  end

  test "should update timesheet" do
    patch timesheet_url(@timesheet), params: { timesheet: { absences_by_certificate: @timesheet.absences_by_certificate, absences_by_permission: @timesheet.absences_by_permission, absences_by_permission_vacation: @timesheet.absences_by_permission_vacation, absences_by_request: @timesheet.absences_by_request, absences_by_sick_leave: @timesheet.absences_by_sick_leave, absences_total: @timesheet.absences_total, absences_with_working_out: @timesheet.absences_with_working_out, check_formula: @timesheet.check_formula, employment_fact_date: @timesheet.employment_fact_date, employment_official_date: @timesheet.employment_official_date, full_name: @timesheet.full_name, note: @timesheet.note, personnel_number: @timesheet.personnel_number, position: @timesheet.position, subdivision_code: @timesheet.subdivision_code, unit: @timesheet.unit, vacation_days_total: @timesheet.vacation_days_total, worked_hours_per_day: @timesheet.worked_hours_per_day, worked_hours_per_night: @timesheet.worked_hours_per_night, worked_hours_per_shift: @timesheet.worked_hours_per_shift, worked_hours_total: @timesheet.worked_hours_total, worked_shifts_total: @timesheet.worked_shifts_total } }
    assert_redirected_to timesheet_url(@timesheet)
  end

  test "should destroy timesheet" do
    assert_difference("Timesheet.count", -1) do
      delete timesheet_url(@timesheet)
    end

    assert_redirected_to timesheets_url
  end
end
