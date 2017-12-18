class CommentsController < ApplicationController
  include SwaggerDocs::Comments

  before_action :set_comment, only: [:show, :update, :destroy]

  # GET /reviews/:review_id/comments
  def index
    @comments = Comment.where(review_id: params[:review_id])

    render json: @comments
  end

  # GET /comments/1
  def show
    render json: @comment
  end

  # POST /reviews/:review_id/comments
  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      render json: @comment, status: :created, location: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def comment_params
      params.require(:comment).permit(:content, :agency_id, :review_id)
    end
end
