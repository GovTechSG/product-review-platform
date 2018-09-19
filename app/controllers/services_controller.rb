class ServicesController < ApplicationController
  include SwaggerDocs::Services
  before_action -> { doorkeeper_authorize! :read_only, :read_write }, only: [:index, :show]
  before_action only: [:create, :update, :destroy, :search] do
    doorkeeper_authorize! :read_write, :write_only
  end
  before_action :set_service, only: [:show, :update, :destroy]
  before_action :validate_service_presence, only: [:show, :update, :destroy]
  before_action :set_company, only: [:index, :create]
  before_action :validate_company_presence, only: [:index, :create]
  before_action :validate_company_uen_name, only: [:search]
  before_action :set_searched_company, only: [:search]
  after_action only: [:index] { set_pagination_header(CompanyReviewable.kept.where(company_id: @company.id, reviewable_type: "Service").map(&:company)) }

  # GET /companies/:company_id/services
  def index
    @services = CompanyReviewable.kept.where(company_id: @company.id, reviewable_type: "Service").map(&:company)

    render json: paginator(@services), methods: [:reviews_count, :aggregate_score], has_type: false
  end

  # GET /services/1
  def show
    render json: @service, methods: [:reviews_count, :aggregate_score, :company_name], has_type: false
  end

  # POST /companies/:company_id/services
  def create
    @service = Service.new(service_params)
    if !@service.save
      render json: @service.errors.messages, status: :unprocessable_entity
      return
    end
    @service.reload
    company_reviewable = CompanyReviewable.new(reviewable: @service, company: @company)
    if company_reviewable.save
      render json: @service, status: :created, location: @service, has_type: false
    else
      render json: company_reviewable.errors.messages, status: :unprocessable_entity
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

  # POST /service/service_name
  def search
    validate_search_params
    return if performed?
    validate_vendor_uen_name
    @searched_vendor = @searched_vendor.nil? ? create_vendor : @searched_vendor
    if Service.kept.find_by(name: params[:service_name]).nil?
      create_service
    else
      render json: { 'service_id': Service.kept.find_by(name: params[:service_name]).hashid }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_service
    @service = Service.find_by_hashid(params[:id])
  end

  def create_service
    service = Service.new(name: params[:service_name], description: params[:service][:description])
    if !service.save
      render json: service.errors.messages, status: :unprocessable_entity
      return
    end

    service.reload
    company_reviewable = CompanyReviewable.new(reviewable: service, company: @searched_vendor)
    if company_reviewable.save
      render json: { 'service_id': service.id }
    else
      render json: company_reviewable.errors.messages, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    search
  end

  def validate_service_presence
    render_error(404, "#{I18n.t('service.key_id')}": [I18n.t('general_error.not_found')]) if @service.nil? || !@service.presence?
  end

  def set_company
    @company = Company.find_by_hashid(params[:company_id])
  end

  def set_searched_company
    @searched_company = create_company if @searched_company.nil?
    if @searched_company.errors.blank?
    else
      render json: @searched_company.errors.messages, status: :unprocessable_entity
    end
  end

  def validate_company_uen_name
    @searched_company = Company.kept.uen_query_sanitizer(params[:company][:uen].downcase.lstrip.strip)
    @searched_company = Company.kept.name_query_sanitizer(params[:company][:name].downcase.lstrip.strip) if @searched_company.nil? || @searched_company.uen.blank?
  end

  def create_company
    company = Company.new(name: params[:company][:name], uen: params[:company][:uen], description: params[:company][:description])
    company.set_image!(@image) if params[:company][:name].present?
    company.errors.blank? && company.save
    company
  end

  def validate_vendor_uen_name
    @searched_vendor = Company.kept.uen_query_sanitizer(params[:vendor_uen].to_s.downcase.lstrip.strip)
    @searched_vendor = Company.kept.name_query_sanitizer(params[:vendor_name].downcase.lstrip.strip) if @searched_vendor.nil? || @searched_vendor.uen.blank?
  end

  def create_vendor
    vendor = Company.new(name: params[:vendor_name], uen: params[:vendor_uen], description: "")
    vendor.set_image!(@image) if params[:vendor_name].present?
    vendor.errors.blank? && vendor.save
    vendor
  end

  def validate_company_presence
    render_error(404, "#{I18n.t('company.key_id')}": [I18n.t('general_error.not_found')]) if @company.nil? || !@company.presence?
  end

  # Only allow a trusted parameter "white list" through.
  def service_params
    params.require(:service).permit(:name, :description, :vendor_uen, :vendor_name)
  end

  def validate_search_params
    render_error(404, "Vendor name or company": [I18n.t('general_error.not_found')]) if params[:vendor_name].nil? || params[:vendor_uen].nil?
  end
end
