class PhonesController < ApplicationController
  
  require 'rubyXL/convenience_methods'

  before_action :set_phone, only: %i[ show edit update destroy ]

  # GET /phones or /phones.json
  def index
    respond_to do |format|
      format.html do
        if params[:query].present?
          @phones = Phone.where("name || ' ' || number ILIKE ?", "%#{params[:query]}%") if params[:query].present? 
        else
          @phones = Phone.order('number')
        end
      end
      format.xlsx do
        @phone = Phone.order('created_at')
        render xlsx: 'Телефоны', template: 'phones/phone'
      end
    end
  end

  # GET /phones/1 or /phones/1.json
  def show
  end

  # GET /phones/new
  def new
    @phone = Phone.new
  end

  # GET /phones/1/edit
  def edit
  end

  # POST /phones or /phones.json
  def create
    @phone = Phone.new(phone_params)

    respond_to do |format|
      if @phone.save
        format.html { redirect_to phone_url(@phone), notice: "Phone was successfully created." }
        format.json { render :show, status: :created, location: @phone }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @phone.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /phones/1 or /phones/1.json
  def update
    respond_to do |format|
      if @phone.update(phone_params)
        format.html { redirect_to phone_url(@phone), notice: "Phone was successfully updated." }
        format.json { render :show, status: :ok, location: @phone }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @phone.errors, status: :unprocessable_entity }
      end
    end
  end

  def import
    Phone.import phones_from(params[:file]), ignore: true
      
    redirect_to phones_path, notice: "Phones imported."
  end

  # DELETE /phones/1 or /phones/1.json
  def destroy
    @phone.destroy

    respond_to do |format|
      format.html { redirect_to phones_url, notice: "Phone was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def phones_from(file)

    sheet = RubyXL::Parser.parse(file)[0]

    sheet[0..0].map do |row| # Первая строка - заголовки
      heads = row.cells[0..2].map { |c| c&.value.to_s }
      @nums = heads.index {|i| i == "Внутренний" } 
      @posi = heads.index {|i| i == "Место установки" } 
      @mame = heads.index {|i| i == "Фамилия, Имя, Отчество" } 
    end

    sheet[1..-1].map do |row| # Все строки со второй
          cells = row.cells[0..2].map { |c| c&.value.to_s }
          colours = row.cells[0..2].map { |c| c&.fill_color }
          Phone.new colour: colours[0],
                    number: cells[@nums.to_i],
                    position: cells[@posi.to_i],
                    name: cells[@mame.to_i]
    end
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_phone
      @phone = Phone.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def phone_params
      params.require(:phone).permit(:number, :name, :colour, :position, :department)
    end
end
