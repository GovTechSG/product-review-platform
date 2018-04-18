class AgenciesController < ApplicationController
  include SwaggerDocs::Agencies
  before_action :doorkeeper_authorize!
  before_action :set_agency, only: [:show, :update, :destroy]
  before_action :validate_agency_pressence, only: [:show, :update, :destroy]

  after_action only: [:index] { set_pagination_header(Agency.kept) }

  # GET /agencies
  def index
    @agencies = Agency.kept.page params[:page]

    render json: @agencies, has_type: false
  end

  # GET /agencies/1
  def show
    render json: @agency, has_type: false
  end

  # POST /agencies
  def create
    @agency = Agency.new(agency_params)
    @agency.set_image!(@image) if agency_params[:name].present?
    if @agency.errors.blank? && @agency.save
      render json: @agency, status: :created, location: @agency, has_type: false
    else
      render json: @agency.errors.messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /agencies/1
  def update
    agency_params
    if !@image.nil?
      @agency.assign_attributes(agency_params)
      @agency.set_image!(@image) if @agency.valid?
    end
    if @agency.errors.blank? && @agency.update(agency_params)
      render json: @agency, has_type: false
    else
      render json: @agency.errors.messages, status: :unprocessable_entity
    end
  end

  # DELETE /agencies/1
  def destroy
    @agency.discard
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_agency
    @agency = Agency.find_by_hashid(params[:id])
  end

  def validate_agency_pressence
    render_error(404, "#{I18n.t('agency.key_id')}": [I18n.t('general_error.not_found')]) if @agency.nil? || !@agency.presence?
  end

  # Only allow a trusted parameter "white list" through.
  def agency_params
    @image = params[:agency][:image] if params[:agency].present? && params[:agency][:image].present?
    params.require(:agency).permit(:name, :email, :phone_number, :acronym, :kind, :description)
  end
end
