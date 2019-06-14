class AqueductsController < ApplicationController
  before_action :set_aqueduct, only: [:show, :update, :destroy]

  # GET /aqueducts
  # GET /aqueducts.json
  def index
    @aqueducts = Aqueduct.all
  end

  # GET /aqueducts/1
  # GET /aqueducts/1.json
  def show
  end

  # POST /aqueducts
  # POST /aqueducts.json
  def create
    @aqueduct = Aqueduct.new(aqueduct_params)

    if @aqueduct.save
      render :show, status: :created, location: @aqueduct
    else
      render json: @aqueduct.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /aqueducts/1
  # PATCH/PUT /aqueducts/1.json
  def update
    if @aqueduct.update(aqueduct_params)
      render :show, status: :ok, location: @aqueduct
    else
      render json: @aqueduct.errors, status: :unprocessable_entity
    end
  end

  # DELETE /aqueducts/1
  # DELETE /aqueducts/1.json
  def destroy
    @aqueduct.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_aqueduct
      @aqueduct = Aqueduct.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def aqueduct_params
      params.require(:aqueduct).permit(:name, :email, :phone)
    end
end
