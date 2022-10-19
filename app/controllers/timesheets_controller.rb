class TimesheetsController < ApplicationController

  require 'rubyXL/convenience_methods'

  before_action :set_timesheet, only: %i[ show edit update destroy ]

  $days_count = 31

  # GET /timesheets or /timesheets.json
  def index
    respond_to do |format|
      format.html do
        if params[:query].present?
          @timesheets = Timesheet.where("personnel_number || ' ' || full_name ILIKE ?", "%#{params[:query]}%") if params[:query].present? 
        else
          @timesheets = Timesheet.order('full_name')
        end
      end
      format.xlsx do
        @timesheet = Timesheet.order('full_name')
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
        format.html { redirect_to timesheets_path, notice: "Timesheet was successfully created." }
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
        format.html { redirect_to timesheets_path, notice: "Timesheet was successfully updated." }
        format.json { render :show, status: :ok, location: @timesheet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @timesheet.errors, status: :unprocessable_entity }
      end
    end
  end

  def import
    Timesheet.import timesheets_from(params[:file]), ignore: true
    redirect_to timesheets_path, notice: "Timesheet imported."
  end

  # DELETE /timesheets/1 or /timesheets/1.json
  def destroy
    @timesheet.destroy
    respond_to do |format|
      format.html { redirect_to timesheets_path, notice: "Timesheet was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def delete_all
    Timesheet.all.map(&:destroy)
    redirect_to timesheets_path, notice: "Timesheets deleted."
  end
  
  private

  def timesheets_from(file)

    sheet = RubyXL::Parser.parse(file)[0]

    sheet[0..0].map do |row| # Первая строка - заголовки
      heads = row.cells[0..52].map { |c| c&.value.to_s }
      @days = heads.select{ _1 =~ /^\d+$/ } # На выходе получим массив дней.
      @days_index_from = 8 # Индекс начала дней
      @days_index_since = @days_index_from + @days.length() - 1 # Индекс конца дней
      $days_count = @days.length()
      #@yavok = heads.index {|i| i == "Явок" } 
      @yavok = @days_index_from + @days.length() 
    end

    sheet[1..-1].map do |row| # Все строки со второй
      cells = row.cells[0..52].map { |c| c&.value.to_s }
      colours = row.cells[6..7].map { |c| c&.fill_color }
      
      Timesheet.new colour: colours[0],
                    unit: cells[0],
                    subdivision_code: cells[1],
                    personnel_number: cells[2],
                    employment_official_date: cells[3].slice(0,10),
                    employment_fact_date: cells[4].slice(0,10),
                    full_name: cells[6],
                    position: cells[7],
                    worked_hours_per_shift: cells[@days_index_from..@days_index_since],
                    worked_shifts_total: cells[@yavok.to_i],
                    worked_hours_total: cells[@yavok.to_i + 1],
                    worked_hours_per_day: cells[@yavok.to_i + 2],
                    worked_hours_per_night: cells[@yavok.to_i + 3],
                    check_formula: cells[@yavok.to_i + 4],
                    absences_total: cells[@yavok.to_i + 5],
                    absences_by_request: cells[@yavok.to_i + 6],
                    absences_by_certificate: cells[@yavok.to_i + 7],
                    absences_by_sick_leave: cells[@yavok.to_i + 8],
                    vacation_days_total: cells[@yavok.to_i + 9],
                    absences_by_permission: cells[@yavok.to_i + 10],
                    absences_with_working_out: cells[@yavok.to_i + 11],
                    absences_by_permission_vacation: cells[@yavok.to_i + 11]
    end
  end
  
  # Use callbacks to share common setup or constraints between actions.
  def set_timesheet
    @timesheet = Timesheet.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def timesheet_params
    params.require(:timesheet).permit(:unit, :subdivision_code, :personnel_number, :employment_official_date, :employment_fact_date, :full_name, :position, :worked_hours_per_shift, :note, :worked_shifts_total, :worked_hours_total, :worked_hours_per_day, :worked_hours_per_night, :check_formula, :absences_total, :absences_by_request, :absences_by_certificate, :absences_by_sick_leave, :vacation_days_total, :absences_by_permission, :absences_with_working_out, :absences_by_permission_vacation, :colour)
  end

end
