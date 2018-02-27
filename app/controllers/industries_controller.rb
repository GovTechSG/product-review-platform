class IndustriesController < ApplicationController
  before_action :set_industry, only: [:show, :update, :destroy]

  # GET /industries
  def index
    @industries = Industry.all

    render json: @industries
  end

  # GET /industries/1
  def show
    render json: @industry
  end

  # POST /industries
  def create
    @industry = Industry.new(industry_params)

    if @industry.save
      render json: @industry, status: :created, location: @industry
    else
      render json: @industry.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /industries/1
  def update
    if @industry.update(industry_params)
      render json: @industry
    else
      render json: @industry.errors, status: :unprocessable_entity
    end
  end

  # DELETE /industries/1
  def destroy
    @industry.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_industry
      @industry = Industry.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def industry_params
      params.require(:industry).permit(:name, :company)
    end
end
