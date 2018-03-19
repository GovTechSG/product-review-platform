class StrengthsController < ApplicationController
  before_action :doorkeeper_authorize!
  before_action :set_strength, only: [:show, :update, :destroy]
  before_action :validate_strength_presence, only: [:show, :update, :destroy]

  # GET /strengths
  def index
    @strengths = Strength.kept

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
      render json: @strength.errors.messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /strengths/1
  def update
    if @strength.update(strength_params)
      render json: @strength
    else
      render json: @strength.errors.messages, status: :unprocessable_entity
    end
  end

  # DELETE /strengths/1
  def destroy
    @strength.discard
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_strength
    @strength = Strength.find_by(id: params[:id])
  end

  def validate_strength_presence
    render_error(404, "Strength id": ["not found."]) if @strength.nil? || !@strength.presence?
  end

  # Only allow a trusted parameter "white list" through.
  def strength_params
    params.require(:strength).permit(:name, :description)
  end
end
