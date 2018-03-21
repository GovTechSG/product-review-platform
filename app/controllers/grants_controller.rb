class GrantsController < ApplicationController
  include SwaggerDocs::Grants
  before_action :doorkeeper_authorize!
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
        @company.grants
      else
        Grant.kept
      end
    render json: @grants
  end

  # GET /grants/1
  def show
    render json: @grant
  end

  # POST /grants
  def create
    @grant = Grant.new(grant_params)

    if @grant.save
      render json: @grant, status: :created, location: @grant
    else
      render json: @grant.errors.messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /grants/1
  def update
    if @grant.update(grant_params)
      render json: @grant
    else
      render json: @grant.errors.messages, status: :unprocessable_entity
    end
  end

  # DELETE /grants/1
  def destroy
    @grant.discard
  end

  private

  def validate_create_params
    if params[:grant].present?
      if agency_id_present?
        agency = set_agency
        render_error(404, "Agency id": ["not found."]) if agency_not_found(agency)
      else
        render_error(400, "Parameter missing": ["param is missing or the value is empty: agency_id"])
      end
    end
  end

  def validate_update_params
    if params[:grant].present?
      if agency_id_present?
        agency = set_agency
        render_error(404, "Agency id": ["not found."]) if agency_not_found(agency)
      end
    end
  end

  def set_agency
    Agency.find_by(id: params[:grant][:agency_id])
  end

  def agency_not_found(agency)
    agency.nil? || !agency.presence?
  end

  def agency_id_present?
    params[:grant][:agency_id].present?
  end

  def set_grant
    @grant = Grant.find_by(id: params[:id])
  end

  def validate_grant_presence
    render_error(404, "Grant id": ["not found."]) if @grant.nil? || !@grant.presence?
  end

  def set_company_if_present
    if params[:company_id].present?
      @company = Company.find_by(id: params[:company_id])
      render_error(404, "Company id": ["not found."]) if @company.nil? || !@company.presence?
    end
  end

  # Only allow a trusted parameter "white list" through.
  def grant_params
    params.require(:grant).permit(:name, :description, :agency_id, :acronym)
  end
end
