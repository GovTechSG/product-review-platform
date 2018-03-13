class CommentsController < ApplicationController
  include SwaggerDocs::Comments
  before_action :doorkeeper_authorize!
  before_action :set_comment, only: [:show, :update, :destroy]
  before_action :validate_comment_pressence, only: [:show, :update, :destroy]
  before_action :set_review, only: [:index, :create]
  before_action :validate_review_presence, only: [:index, :create]
  before_action :set_new_comment, only: [:create]
  before_action :validate_user_presence, only: [:create]

  # GET /reviews/:review_id/comments
  def index
    @comments = Comment.kept.where(review_id: params[:review_id])
    render json: @comments, methods: [:user]
  end

  # GET /comments/1
  def show
    render json: @comment
  end

  # POST /reviews/:review_id/comments
  def create
    if @comments.save
      render json: @comments, status: :created, location: @comments
    else
      render json: @comments.errors.messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(update_params)
      render json: @comment
    else
      render json: @comment.errors.messages, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.discard
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find_by(id: params[:id])
    end

    def set_review
      @review = Review.find_by(id: params[:review_id])
    end

    def set_new_comment
      @comments = Comment.new(create_params.merge(review_id: params[:review_id]))
    end

    def validate_comment_pressence
      render_error(404, "Comment id": ["not found"]) if @comment.nil? || !@comment.presence?
    end

    def validate_user_presence
      render_error(404, "User id": ["not found"]) if User.find_by(id: @comments.user_id).nil?
    end

    def validate_review_presence
      render_error(404, "Review id": ["not found"]) if @review.nil? || !@review.presence?
    end

    # Only allow a trusted parameter "white list" through.
    def create_params
      params.require(:comment).permit(:content, :user_id)
    end

    def update_params
      params.require(:comment).permit(:content)
    end
end
