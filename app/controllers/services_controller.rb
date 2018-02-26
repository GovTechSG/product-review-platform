class ServicesController < ApplicationController
  include SwaggerDocs::Services
  before_action :doorkeeper_authorize!
  before_action :set_service, only: [:show, :update, :destroy]
  before_action :validate_service_pressence, only: [:show, :update, :destroy]
  before_action :set_service_by_company, only: [:index]
  before_action :validate_company_pressence, only: [:index]
  before_action :set_new_service, only: [:create]
  before_action :validate_new_creation, only: [:create]



  # GET /companies/:company_id/services
  def index
    render json: @services, methods: [:reviews_count, :aggregate_score]
  end

  # GET /services/1
  def show
    render json: @service, methods: [:reviews_count, :aggregate_score, :company_name]
  end

  # POST /companies/:company_id/services
  def create
    if @services.save
      render json: @services, status: :created, location: @services
    else
      render json: @services.errors, status: :unprocessable_entity
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

    def set_service_by_company
      @services = Service.find_by(company_id: params[:company_id])
    end

    def set_new_service
      @services = Service.new(service_params.merge(company_id: params[:company_id]))
    end

    def validate_service_pressence
      render_error(404) if @service.nil?
    end

    def validate_company_pressence
      render_error(404, "Company_id entered does not exist") if @services.nil?
    end

    def validate_new_creation
      render_error(404, "Company_id entered does not exist") if (Company.find_by(id: @services.company_id)).nil?
    end

    # Only allow a trusted parameter "white list" through.
    def service_params
      params.require(:service).permit(:name, :description)
    end
end
