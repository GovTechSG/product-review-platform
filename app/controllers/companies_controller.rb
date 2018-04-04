class CompaniesController < ApplicationController
  include SwaggerDocs::Companies
  before_action :doorkeeper_authorize!
  before_action :set_company, only: [:show, :update, :destroy]
  before_action :set_company_by_company_id, only: [:clients]
  before_action :validate_company_presence, only: [:show, :update, :destroy, :clients]
  before_action :set_industry, only: [:create, :update]
  before_action :validate_industry_presence, only: [:create, :update]

  # GET /companies
  def index
    @companies = Company.kept
    render json: @companies, methods: [:strengths], has_type: false
  end

  # GET /companies/:company_id/clients
  def clients
    render json: @company.clients, has_type: false
  end

  # GET /companies/1
  def show
    render json: @company, methods: [:strengths], has_type: false
  end

  # POST /companies
  def create
    @company = Company.new(company_params)

    if @company.save
      render json: @company, status: :created, location: @company, has_type: false
    else
      render json: @company.errors.messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/1
  def update
    if @company.update(company_params)
      render json: @company, has_type: false
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

    def set_company_by_company_id
      @company = Company.find_by(id: params[:company_id])
    end

    def validate_company_presence
      render_error(404, "#{I18n.t('company.key_id')}": [I18n.t('general_error.not_found')]) if @company.nil? || !@company.presence?
    end

    def set_industry
      if params[:company].present?
        @industry = Industry.find_by(id: params[:company][:industry_ids]) if params[:company][:industry_ids].present?
      else
        render_error(400, "#{I18n.t('general_error.params_missing_key')}": [I18n.t('general_error.params_missing_value', model: "company")])
      end
    end

    def validate_industry_presence
      if params[:company][:industry_ids].present?
        render_error(404, "#{I18n.t('industry.key_id')}": [I18n.t('general_error.not_found')]) if @industry.nil? || !@industry.presence?
      end
    end

    # Only allow a trusted parameter "white list" through.
    def company_params
      params.require(:company).permit(:name, :uen, :description, :phone_number, :url, industry_ids: [])
    end
end
