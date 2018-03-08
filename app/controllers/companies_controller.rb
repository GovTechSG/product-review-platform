class CompaniesController < ApplicationController
  include SwaggerDocs::Companies
  before_action :doorkeeper_authorize!
  before_action :set_company, only: [:show, :update, :destroy]

  # GET /companies
  def index
    @companies = Company.kept
    render json: @companies, methods: [:reviews_count, :strengths]
  end

  # GET /companies/1
  def show
    render json: @company, methods: [:reviews_count, :strengths]
  end

  # POST /companies
  def create
    @company = Company.new(company_params)

    if @company.save
      render json: @company, status: :created, location: @company
    else
      render_error(422)
    end
  end

  # PATCH/PUT /companies/1
  def update
    if @company.update(company_params)
      render json: @company
    else
      render_error(422)
    end
  end

  # DELETE /companies/1
  def destroy
    @company.discard
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find_by(id: params[:id])
      if @company.nil? || !@company.presence?
        render_error(404)
      else
        @company
      end
    end

    # Only allow a trusted parameter "white list" through.
    def company_params
      params.require(:company).permit(:name, :UEN, :description)
    end
end
