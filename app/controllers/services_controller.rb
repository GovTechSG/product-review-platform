class ServicesController < ApplicationController
  include SwaggerDocs::Services
  before_action :doorkeeper_authorize!
  before_action :set_service, only: [:show, :update, :destroy]
  before_action :validate_service_presence, only: [:show, :update, :destroy]
  before_action :set_company, only: [:index, :create]
  before_action :validate_company_presence, only: [:index, :create]

  # GET /companies/:company_id/services
  def index
    @services = Service.where(company_id: params[:company_id], discarded_at: nil)

    render json: @services, methods: [:reviews_count, :aggregate_score]
  end

  # GET /services/1
  def show
    render json: @service, methods: [:reviews_count, :aggregate_score, :company_name]
  end

  # POST /companies/:company_id/services
  def create
    @service = Service.new(service_params.merge(company_id: params[:company_id]))

    if @service.save
      render json: @service, status: :created, location: @service
    else
      render json: @service.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /services/1
  def update
    if @service.update(service_params)
      render json: @service
    else
      render json: @service.errors, status: :unprocessable_entity
    end
  end

  # DELETE /services/1
  def destroy
    @service.discard
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find_by(id: params[:id])
    end

    def validate_service_presence
      render_error(404) if @service.nil? || @service.discarded? || @service.company.discarded?
    end

    def set_company
      @company = Company.find_by(id: params[:company_id])
    end

    def validate_company_presence
      render_error(404, "Company id not found.") if @company.nil? || @company.discarded?
    end

    # Only allow a trusted parameter "white list" through.
    def service_params
      params.require(:service).permit(:name, :description)
    end
end
