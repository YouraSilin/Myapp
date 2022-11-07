class WorkedHoursController < ApplicationController

  # GET /timesheets/new
  def new
    @worked_hour = Worked_hours.new
  end

  # GET /timesheets/1/edit
  def edit
  end

  # POST /timesheets or /timesheets.json
  def create
    @worked_hour = Worked_hours.new(worked_hours_params)

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
      if @worked_hour.update(worked_hours_params)
        format.html { redirect_to timesheets_path, notice: "строка изменена" }
        format.json { render :show, status: :ok, location: @timesheet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @timesheet.errors, status: :unprocessable_entity }
      end
    end
  end

  
  # DELETE /timesheets/1 or /timesheets/1.json
  def destroy
    @worked_hour.destroy
    respond_to do |format|
      format.html { redirect_to timesheets_path, notice: "строка удалена" }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_timesheet
    @worked_hour = Worked_hours.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def worked_hours_params
    params.require(:worked_hours).permit(:hours, :note, :fill)
  end
end