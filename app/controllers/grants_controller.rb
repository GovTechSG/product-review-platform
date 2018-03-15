class GrantsController < ApplicationController
  include SwaggerDocs::Grants
  before_action :doorkeeper_authorize!
  before_action :set_grant, only: [:show, :update, :destroy]
  before_action :validate_grant_presence, only: [:show, :update, :destroy]
  before_action :set_company_if_present, only: [:index]

  # GET /grants
  # GET /companies/:company_id/grants
  def index
    @grants =
      if @company
        Grant.kept.find_by_sql [company_grants_sql_string, { company_id: @company.id }]
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

  def company_grants_sql_string
    "SELECT *
     FROM grants
     WHERE id IN (
       SELECT DISTINCT r.grant_id
       FROM reviews r
       JOIN products p ON r.reviewable_id = p.id
       WHERE r.reviewable_type = 'Product'
       AND r.reviewer_type = 'Company'
       AND p.company_id = :company_id
       AND r.discarded_at IS NULL AND p.discarded_at IS NULL
       UNION
       SELECT DISTINCT r.grant_id
       FROM reviews r
       JOIN services s ON r.reviewable_id = s.id
       WHERE r.reviewable_type = 'Service'
       AND r.reviewer_type = 'Company'
       AND s.company_id = :company_id
       AND r.discarded_at IS NULL AND s.discarded_at IS NULL
     )
     AND discarded_at IS NULL"
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
