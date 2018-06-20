class ServicesController < ApplicationController
  include SwaggerDocs::Services
  before_action :doorkeeper_authorize!
  before_action :set_service, only: [:show, :update, :destroy]
  before_action :validate_service_presence, only: [:show, :update, :destroy]
  before_action :set_company, only: [:index, :create]
  before_action :validate_company_presence, only: [:index, :create]
  before_action :set_company_by_name, only: [:search]

  after_action only: [:index] { set_pagination_header(Service.kept.where(company_id: params[:company_id])) }

  # GET /companies/:company_id/services
  def index
    @services = params[:page] == 'all' ? Service.kept.where(company_id: @company.id) : Service.kept.where(company_id: @company.id).page(params[:page])

    render json: @services, methods: [:reviews_count, :aggregate_score], has_type: false
  end

  # GET /services/1
  def show
    render json: @service, methods: [:reviews_count, :aggregate_score, :company_name], has_type: false
  end

  # POST /companies/:company_id/services
  def create
    @service = Service.new(service_params.merge(company_id: @company.id))

    if @service.save
      render json: @service, status: :created, location: @service, has_type: false
    else
      render json: @service.errors.messages, status: :unprocessable_entity
    end
  end

  # POST /service/service_name
  def search
    if Service.kept.find_by(name: params[:service_name]).nil?
      create_service
    else
      render json: { 'service_id': Service.kept.find_by(name: params[:service_name]).hashid }
    end
  end

  # PATCH/PUT /services/1
  def update
    if @service.update(service_params)
      render json: @service, has_type: false
    else
      render json: @service.errors.messages, status: :unprocessable_entity
    end
  end

  # DELETE /services/1
  def destroy
    @service.discard
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find_by_hashid(params[:id])
    end

    def create_service
      service = Service.create(company_id: @searched_company.id, name: params[:service_name], description: params[:service][:description])
      if service.errors.blank?
        render json: { 'service_id': service.hashid }
      else
        render json: service.errors.messages, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotUnique
      search
    end

    def set_company_by_name
      @searched_company = Company.kept.find_by(uen: params[:company][:uen])
      @searched_company = create_company if @searched_company.nil?
      if @searched_company.errors.blank?
      else
        render json: @searched_company.errors.messages, status: :unprocessable_entity
      end
    end

    def create_company
      company = Company.new(name: params[:company][:name], uen: params[:company][:uen], description: params[:company][:description])
      company.set_image!(@image) if params[:company][:name].present?
      company.errors.blank? && company.save
      company
    end

    def validate_service_presence
      render_error(404, "#{I18n.t('service.key_id')}": [I18n.t('general_error.not_found')]) if @service.nil? || !@service.presence?
    end

    def set_company
      @company = Company.find_by_hashid(params[:company_id])
    end

    def validate_company_presence
      render_error(404, "#{I18n.t('company.key_id')}": [I18n.t('general_error.not_found')]) if @company.nil? || !@company.presence?
    end

    # Only allow a trusted parameter "white list" through.
    def service_params
      params.require(:service).permit(:name, :description)
    end
end
