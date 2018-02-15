class LikesController < ApplicationController
  include SwaggerDocs::Likes
  before_action :doorkeeper_authorize!
  before_action :set_like, only: [:show, :update, :destroy]

  # GET /reviews/:review_id/likes
  def index
    @likes = Like.where(review_id: params[:review_id])

    render json: @likes, methods: [:agency]
  end

  # GET /likes/1
  def show
    render json: @like
  end

  # POST /reviews/:review_id/likes
  def create
    @like = Like.new(create_params)

    if @like.save
      render json: @like, status: :created, location: @like
    else
      render json: @like.errors, status: :unprocessable_entity
    end
  end

  # DELETE /likes/1
  def destroy
    @like.discard
    render json: nil, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_like
      @like = Like.find_by(id: params[:id])
      render_id_not_found if @like.nil?
    end

    # Only allow a trusted parameter "white list" through.
    def create_params
      params.require(:like).permit(:agency_id).merge(review_id: params[:review_id])
    end
end
