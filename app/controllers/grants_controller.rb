class GrantsController < ApplicationController
  include SwaggerDocs::Grants
  before_action -> { doorkeeper_authorize! :read_only, :read_write }, only: [:index, :show, :search]
  before_action only: [:create, :update, :destroy] do
    doorkeeper_authorize! :read_write, :write_only
  end
  before_action :set_grant, only: [:show, :update, :destroy]
  before_action :validate_grant_presence, only: [:show, :update, :destroy]
  before_action :set_company_if_present, only: [:index]
  before_action :validate_create_params, only: [:create]
  before_action :validate_update_params, only: [:update]

  # GET /grants
  # GET /companies/:company_id/grants
  def index
    @grants =
      if @company
        @company.grants(params[:filter_by], params[:sort_by], params[:desc])
      else
        Grant.kept.order(name: :asc)
      end

    headers["Total"] = @grants.count
    headers["Per-Page"] = params[:per_page]

    render json: (params[:page] == 'all' ? @grants : paginator(@grants)), has_type: false
  end

  # GET /grants/1
  def show
    render json: @grant, has_type: false
  end

  # POST /grants
  def create
    convert_hashids
    @grant = Grant.new(@whitelisted)

    if @grant.save
      render json: @grant, status: :created, location: @grant, has_type: false
    else
      render json: @grant.errors.messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /grants/1
  def update
    convert_hashids
    if @grant.update(@whitelisted)
      render json: @grant, has_type: false
    else
      render json: @grant.errors.messages, status: :unprocessable_entity
    end
  end

  # DELETE /grants/1
  def destroy
    @grant.discard
  end

  # GET
  def search
    grant = Grant.kept.find_by(name: params[:grant_name])
    render json: { grant_id: grant.hashid }
  end

  private

  def validate_create_params
    if params[:grant].present?
      if agency_id_present?
        agency = set_agency
        render_error(404, "#{I18n.t('agency.key_id')}": [I18n.t('general_error.not_found')]) if agency_not_found(agency)
      else
        render_error(400, "#{I18n.t('general_error.params_missing_key')}": [I18n.t('general_error.params_missing_value', model: "agency_id")])
      end
    end
  end

  def validate_update_params
    if params[:grant].present?
      if agency_id_present?
        agency = set_agency
        render_error(404, "#{I18n.t('agency.key_id')}": [I18n.t('general_error.not_found')]) if agency_not_found(agency)
      end
    end
  end

  def set_agency
    Agency.find_by_hashid(params[:grant][:agency_id])
  end

  def agency_not_found(agency)
    agency.nil? || !agency.presence?
  end

  def agency_id_present?
    params[:grant][:agency_id].present?
  end

  def set_grant
    @grant = Grant.find_by_hashid(params[:id])
  end

  def validate_grant_presence
    render_error(404, "#{I18n.t('grant.key_id')}": [I18n.t('general_error.not_found')]) if @grant.nil? || !@grant.presence?
  end

  def set_company_if_present
    if params[:company_id].present?
      @company = Company.find_by_hashid(params[:company_id])
      render_error(404, "#{I18n.t('company.key_id')}": [I18n.t('general_error.not_found')]) if @company.nil? || !@company.presence?
    end
  end

  # Only allow a trusted parameter "white list" through.
  def grant_params
    @whitelisted = params.require(:grant).permit(:name, :description, :agency_id, :acronym)
  end

  def convert_hashids
    grant_params
    if !@whitelisted["agency_id"].nil?
      agency = Agency.find(@whitelisted["agency_id"])
      @whitelisted["agency_id"] = agency.id
    end
  end
end
