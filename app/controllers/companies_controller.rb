class CompaniesController < ApplicationController
  include SwaggerDocs::Companies
  before_action :doorkeeper_authorize!
  before_action :set_company, only: [:show, :update, :destroy]
  before_action :validate_company_presence, only: [:show, :update, :destroy]
  before_action :set_industry, only: [:create, :update]
  before_action :validate_industry_presence, only: [:create, :update]

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
      render json: @company.errors.messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/1
  def update
    if @company.update(company_params)
      render json: @company
    else
      render json: @company.errors.messages, status: :unprocessable_entity
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
    end

    def validate_company_presence
      render_error(404, "Company id": ["not found."]) if @company.nil? || !@company.presence?
    end

    def set_industry
      if params[:company].present? && params[:company][:industry_ids].present?
        @industry = Industry.find_by(id: params[:company][:industry_ids])
      else
        render_error(400, "Industry id": ["not provided"])
      end
    end

    def validate_industry_presence
      render_error(404, "Industry id": ["not found."]) if @industry.nil? || !@industry.presence?
    end

    # Only allow a trusted parameter "white list" through.
    def company_params
      params.require(:company).permit(:name, :uen, :description, :phone_number, :url, industry_ids: [])
    end
end
