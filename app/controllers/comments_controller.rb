class CommentsController < ApplicationController
  include SwaggerDocs::Comments
  before_action :doorkeeper_authorize!
  before_action :set_comment, only: [:show, :update, :destroy]
  before_action :set_comment_by_review, only: [:index]
  before_action :validate_review_pressence, only: [:index]
  before_action :set_new_comment, only: [:create]
  before_action :validate_new_creation, only: [:create]
  before_action :validate_user_presence, only: [:create]

  # GET /reviews/:review_id/comments
  def index
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
      render json: @comments.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(update_params)
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.discard
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def set_comment_by_review
      @comments = Comment.find_by(review_id: params[:review_id])
    end

    def set_new_comment
      @comments = Comment.new(create_params.merge(review_id: params[:review_id]))
    end

    def validate_user_presence
      render_error(404, "User_id entered does not exist") if User.find_by(id: @comments.user_id).nil?
    end

    def validate_review_pressence
      render_error(404, "Review_id entered does not exist") if @comments.nil?
    end

    def validate_new_creation
      render_error(404, "Review_id entered does not exist") if Review.find_by(id: @comments.review_id).nil?
    end

    # Only allow a trusted parameter "white list" through.
    def create_params
      params.require(:comment).permit(:content, :user_id)
    end

    def update_params
      params.require(:comment).permit(:content)
    end
end
