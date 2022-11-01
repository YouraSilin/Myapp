class TimesheetsController < ApplicationController
  before_action :set_timesheet, only: %i[ show edit update destroy ]

  $days_count = 31
  

  # GET /timesheets or /timesheets.json
  def index
    respond_to do |format|
      format.html do
        if params[:query].present?
          @timesheets = Timesheet.includes(:worked_hours).where("personnel_number || ' ' || full_name ILIKE ?", "%#{params[:query]}%") if params[:query].present? 
        else
          @timesheets = Timesheet.includes(:worked_hours).order('created_at')
        end
      end
      format.xlsx do
        @timesheet = Timesheet.includes(:worked_hours).order('full_name')
        render xlsx: 'Табели', template: 'timesheets/timesheet'
      end
    end
  end

  # GET /timesheets/1 or /timesheets/1.json
  def show
  end

  # GET /timesheets/new
  def new
    @timesheet = Timesheet.new
  end

  # GET /timesheets/1/edit
  def edit
  end

  # POST /timesheets or /timesheets.json
  def create
    @timesheet = Timesheet.new(timesheet_params)

    respond_to do |format|
      if @timesheet.save
        format.html { redirect_to timesheets_path, notice: "строка добавлена" }
        format.json { render :show, status: :created, location: @timesheet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @timesheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /timesheets/1 or /timesheets/1.json
  def update
    respond_to do |format|
      if @timesheet.update(timesheet_params)
        format.html { redirect_to timesheets_path, notice: "строка изменена" }
        format.json { render :show, status: :ok, location: @timesheet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @timesheet.errors, status: :unprocessable_entity }
      end
    end
  end

  def import
    Timesheets::Import.call(params[:file])

    redirect_to timesheets_path, notice: "#{$timesheets_imported_count} строк импортировано"
  end

  # DELETE /timesheets/1 or /timesheets/1.json
  def destroy
    @timesheet.destroy
    respond_to do |format|
      format.html { redirect_to timesheets_path, notice: "строка удалена" }
      format.json { head :no_content }
    end
  end

  def delete_all
    tc = Timesheet.count
    Timesheet.all.map(&:destroy)
    redirect_to timesheets_path, notice: "#{tc} строк удалено"
  end

  def delete_empty
    tc = 0
    Timesheet.count.times do
      @timesheet = Timesheet.find{ |i| i.personnel_number == '' }
      if @timesheet then
        tc = tc + 1
      end
      @timesheet&.destroy
    end
    redirect_to timesheets_path, notice: "#{tc} пустых строк удалено"
  end

  def delete_duplicates
      @timesheets = Timesheet.includes(:worked_hours).all
      @timesheets = @timesheets - @timesheets.uniq{ |timesheet| [timesheet.subdivision_code, timesheet.full_name, timesheet.worked_shifts_total, timesheet.worked_hours.count, timesheet.worked_hours_total, timesheet.worked_hours_per_day, timesheet.worked_hours_per_night, timesheet.absences_total, timesheet.absences_by_request, timesheet.absences_by_certificate, timesheet.absences_by_sick_leave, timesheet.vacation_days_total, timesheet.absences_by_permission, timesheet.absences_with_working_out, timesheet.absences_by_permission_vacation] }
      tc = @timesheets.count
      @timesheets.map(&:destroy)
    redirect_to timesheets_path, notice: "#{tc} дублей удалены"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_timesheet
    @timesheet = Timesheet.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def timesheet_params
    params.require(:timesheet).permit(:unit, :subdivision_code, :personnel_number, :employment_official_date, :employment_fact_date, :full_name, :position, :worked_hours_per_shift, :note, :worked_shifts_total, :worked_hours_total, :worked_hours_per_day, :worked_hours_per_night, :check_formula, :absences_total, :absences_by_request, :absences_by_certificate, :absences_by_sick_leave, :vacation_days_total, :absences_by_permission, :absences_with_working_out, :absences_by_permission_vacation, :colour)
  end
end