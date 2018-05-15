class ProjectsController < ApplicationController
  include SwaggerDocs::Projects
  before_action :doorkeeper_authorize!
  before_action :set_project, only: [:show, :update, :destroy]
  before_action :validate_project_presence, only: [:show, :update, :destroy]
  before_action :set_company, only: [:index, :create]
  before_action :validate_company_presence, only: [:index, :create]

  after_action only: [:index] { set_pagination_header(Project.kept.where(company_id: params[:company_id])) }

  # GET /companies/:company_id/projects
  def index
    @projects = Project.kept.where(company_id: @company.id).page params[:page]

    render json: @projects, methods: [:reviews_count, :aggregate_score], has_type: false
  end

  # GET /projects/1
  def show
    render json: @project, methods: [:reviews_count, :aggregate_score, :company_name], has_type: false
  end

  # POST /companies/:company_id/projects
  def create
    @project = Project.new(project_params.merge(company_id: @company.id))

    if @project.save
      render json: @project, status: :created, location: @project, has_type: false
    else
      render json: @project.errors.messages, status: :unprocessable_entity
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

  # GET /project/project_name
  def find_project
    if Project.find_by_name(params[:project_name]).nil?
      # Project.create()
      @project_id = {'project_id':'need to create'}
      render json: {'project_id':Project.first.hashid}
    else
      render json: {'project_id':Project.find_by_name(params[:project_name]).hashid }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find_by_hashid(params[:id])
    end

    def validate_project_presence
      render_error(404, "#{I18n.t('project.key_id')}": [I18n.t('general_error.not_found')]) if @project.nil? || !@project.presence?
    end

    def set_company
      @company = Company.find_by_hashid(params[:company_id])
    end

    def validate_company_presence
      render_error(404, "#{I18n.t('company.key_id')}": [I18n.t('general_error.not_found')]) if @company.nil? || !@company.presence?
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.require(:project).permit(:name, :description)
    end
end
