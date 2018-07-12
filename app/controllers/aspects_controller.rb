class AspectsController < ApplicationController
  include SwaggerDocs::Aspects
  before_action -> { doorkeeper_authorize! :read_only, :read_write }, only: [:index, :show]
  before_action only: [:create, :update, :destroy] do
    doorkeeper_authorize! :read_write, :write_only
  end

  before_action :set_company_by_company_id, only: [:company_aspects]
  before_action :validate_company_presence, only: [:company_aspects]
  before_action :set_aspect, only: [:show, :update, :destroy]
  before_action :validate_aspect_presence, only: [:show, :update, :destroy]

  after_action only: [:index] { set_pagination_header(Aspect.kept) }

  # GET /aspects
  def index
    @aspects = params[:page] == 'all' ? Aspect.kept : Aspect.kept.page(params[:page]).per(params[:per_page])

    render json: @aspects
  end

  # GET /companies/:company_id/aspects
  def company_aspects
    if !performed?
      aspect_list = @company.aspects(params[:filter_by_score], params[:sort_by], params[:count])
      headers["Total"] = aspect_list.length
      if !aspect_list.first.is_a? Aspect
        aspect_list.each do |aspect|
          aspect[:aspect] = ActiveModel::SerializableResource.new(aspect[:aspect])
        end
      end
      render json: paginator(aspect_list)
    end
  end

  # GET /aspects/1
  def show
    render json: @aspect
  end

  # POST /aspects
  def create
    @aspect = Aspect.new(aspect_params)

    if @aspect.save
      render json: @aspect, status: :created, location: @aspect
    else
      render json: @aspect.errors.messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /aspects/1
  def update
    if @aspect.update(aspect_params)
      render json: @aspect
    else
      render json: @aspect.errors.messages, status: :unprocessable_entity
    end
  end

  # DELETE /aspects/1
  def destroy
    @aspect.discard
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_aspect
    @aspect = Aspect.find_by_hashid(params[:id])
  end

  def validate_aspect_presence
    render_error(404, "#{I18n.t('aspect.key_id')}": [I18n.t('general_error.not_found')]) if @aspect.nil? || !@aspect.presence?
  end

  # Only allow a trusted parameter "white list" through.
  def aspect_params
    params.require(:aspect).permit(:name, :description)
  end

  def set_company_by_company_id
    @company = Company.find_by_hashid(params[:company_id])
  end

  def validate_company_presence
    render_error(404, "#{I18n.t('company.key_id')}": [I18n.t('general_error.not_found')]) if @company.nil? || !@company.presence?
  end
end
