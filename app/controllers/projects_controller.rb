class ProjectsController < ApplicationController
  include SwaggerDocs::Projects
  before_action -> { doorkeeper_authorize! :read_only, :read_write }, only: [:index, :show]
  before_action only: [:create, :update, :destroy, :search] do
    doorkeeper_authorize! :read_write, :write_only
  end
  before_action :set_project, only: [:show, :update, :destroy]
  before_action :validate_project_presence, only: [:show, :update, :destroy]
  before_action :set_company, only: [:index, :create]
  before_action :validate_company_presence, only: [:index, :create]
  before_action :validate_company_uen_name, only: [:search]
  before_action :set_searched_company, only: [:search]
  after_action only: [:index] { set_pagination_header(CompanyReviewable.kept.where(company_id: @company.id, reviewable_type: "Project").map(&:company)) }

  # GET /companies/:company_id/projects
  def index
    @projects = CompanyReviewable.kept.where(company_id: @company.id, reviewable_type: "Project").map(&:company)

    render json: paginator(@projects), methods: [:reviews_count, :aggregate_score], has_type: false
  end

  # GET /projects/1
  def show
    render json: @project, methods: [:reviews_count, :aggregate_score, :company_name], has_type: false
  end

  # POST /companies/:company_id/projects
  def create
    @project = Project.new(project_params)
    if !@project.save
      render json: @project.errors.messages, status: :unprocessable_entity
      return
    end
    @project.reload
    company_reviewable = CompanyReviewable.new(reviewable: @project, company: @company)
    if company_reviewable.save
      render json: @project, status: :created, location: @project, has_type: false
    else
      render json: company_reviewable.errors.messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      render json: @project, has_type: false
    else
      render json: @project.errors.messages, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1
  def destroy
    @project.discard
  end

  # POST /project/project_name
  def search
    validate_search_params
    return if performed?
    validate_vendor_uen_name
    @searched_vendor = @searched_vendor.nil? ? create_vendor : @searched_vendor
    if Project.kept.find_by(name: params[:project_name]).nil?
      create_project
    else
      render json: { 'project_id': Project.kept.find_by(name: params[:project_name]).hashid }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find_by_hashid(params[:id])
  end

  def create_project
    project = Project.new(name: params[:project_name], description: params[:project][:description])
    if !project.save
      render json: project.errors.messages, status: :unprocessable_entity
      return
    end

    project.reload
    company_reviewable = CompanyReviewable.new(reviewable: project, company: @searched_vendor)
    if company_reviewable.save
      render json: { 'project_id': project.id }
    else
      render json: company_reviewable.errors.messages, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    search
  end

  def validate_project_presence
    render_error(404, "#{I18n.t('project.key_id')}": [I18n.t('general_error.not_found')]) if @project.nil? || !@project.presence?
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
  def project_params
    params.require(:project).permit(:name, :description, :vendor_uen, :vendor_name)
  end

  def validate_search_params
    render_error(404, "Vendor name or company": [I18n.t('general_error.not_found')]) if params[:vendor_name].nil? || params[:vendor_uen].nil?
  end
end
