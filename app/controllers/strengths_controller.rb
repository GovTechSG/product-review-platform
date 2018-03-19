class StrengthsController < ApplicationController
  before_action :set_strength, only: [:show, :update, :destroy]

  # GET /strengths
  def index
    @strengths = Strength.all

    render json: @strengths
  end

  # GET /strengths/1
  def show
    render json: @strength
  end

  # POST /strengths
  def create
    @strength = Strength.new(strength_params)

    if @strength.save
      render json: @strength, status: :created, location: @strength
    else
      render json: @strength.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /strengths/1
  def update
    if @strength.update(strength_params)
      render json: @strength
    else
      render json: @strength.errors, status: :unprocessable_entity
    end
  end

  # DELETE /strengths/1
  def destroy
    @strength.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_strength
      @strength = Strength.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def strength_params
      params.require(:strength).permit(:name, :description)
    end
end
