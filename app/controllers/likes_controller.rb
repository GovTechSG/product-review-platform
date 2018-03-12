class LikesController < ApplicationController
  include SwaggerDocs::Likes
  before_action :doorkeeper_authorize!
  before_action :set_like, only: [:show, :update, :destroy]
  before_action :validate_like_pressence, only: [:show, :update, :destroy]
  before_action :set_review, only: [:create, :index]
  before_action :validate_review_pressence, only: [:create, :index]

  # GET /reviews/:review_id/likes
  def index
    @likes = Like.kept.where(review_id: params[:review_id])

    render json: @likes, methods: [:user]
  end

  # GET /likes/1
  def show
    render json: @like
  end

  # POST /reviews/:review_id/likes
  def create
    @user = User.kept.find_by(id: create_params[:user_id])
    if @user.nil?
      render_error(404, "User id not found")
      return
    end
    @like = Like.new(create_params)

    if @like.save
      render json: @like, status: :created, location: @like
    else
      render json: @like.errors.messages, status: :unprocessable_entity
    end
  end

  # DELETE /likes/1
  def destroy
    @like.discard
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_like
      @like = Like.kept.find_by(id: params[:id])
    end

    def validate_like_pressence
      render_error(404, "Like id not found") if @like.nil? || !@like.presence?
    end

    def set_review
      @review = Review.kept.find_by(id: params[:review_id])
    end

    def validate_review_pressence
      render_error(404, "Review id not found") if @review.nil? || !@review.presence?
    end

    # Only allow a trusted parameter "white list" through.
    def create_params
      params.require(:like).permit(:user_id).merge(review_id: params[:review_id])
    end
end
