class CommentsController < ApplicationController
  include SwaggerDocs::Comments
  before_action :doorkeeper_authorize!

  before_action :set_commentable, only: [:index, :create]

  before_action :set_comment, only: [:show, :update, :destroy]
  before_action :validate_comment_pressence, only: [:show, :update, :destroy]
  before_action :set_update_commentable, only: [:update]
  before_action :validate_commentable_presence, only: [:index, :create, :update]
  before_action :validate_from_presence, only: [:update]
  before_action :validate_update_commenter_presence, only: [:update]


  before_action :check_commenter_params, only: [:create]
  before_action :set_new_comment_commenter, only: [:create]
  before_action :validate_commenter_presence, only: [:create]

  BOTH_PARAMS_EXIST = 0
  BOTH_PARAMS_MISSING = 2
  PARTIAL_PARAMS_MISSING = 1

  # GET /reviews/:review_id/comments
  def index
    @comments = @commentable.comments.kept
    render json: @comments
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
    if @comment.update(@whitelisted)
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
    def change_params_key
      @whitelisted["commenter_id"] = @whitelisted["from_id"]
      @whitelisted.delete("from_id")
      @whitelisted["commenter_type"] = @whitelisted["from_type"].classify.safe_constantize
      @whitelisted.delete("from_type")
    end

    def check_from_presence
      if params[:comment].present? && params[:comment][:from_type].present? && params[:comment][:from_id].present?
        BOTH_PARAMS_EXIST
      elsif params[:comment][:from_type].blank? && params[:comment][:from_id].blank?
        @whitelisted = update_params
        BOTH_PARAMS_MISSING
      else
        PARTIAL_PARAMS_MISSING
      end
    end

    def validate_from_presence
      if check_from_presence == PARTIAL_PARAMS_MISSING
        render_error(422, "Either From type or From ID": ["is missing"])
      elsif check_from_presence == BOTH_PARAMS_EXIST
        type = params[:comment][:from_type].classify.safe_constantize
        if !type.nil? && type.superclass.name == "Commenter"
          @whitelisted = update_params
          change_params_key
        else
          render_error(422, "From type": ["is invalid"])
        end
      end
    end

    def set_comment
      @comment = Comment.find_by(id: params[:id])
    end

    def set_new_comment_commenter
      type = params[:comment][:from_type].classify.safe_constantize if !params[:comment][:from_type].nil?
      if !type.nil?
        if type.superclass.name != "Commenter"
          render_error(422, "From type": ["is invalid"])
        else
          @commmenter = type.find_by(id: params[:comment][:from_id])
          @whitelisted = create_params
          change_params_key
          @comments = Comment.new(@whitelisted)
        end
      else
        render_error(422, "From type": ["is invalid"])
      end
    end

    def validate_comment_pressence
      render_error(404, "Comment id": ["not found"]) if @comment.nil? || !@comment.presence?
    end

    def check_commenter_params
      if params[:comment].present?
        if !(params[:comment][:from_id].present? && params[:comment][:from_type].present?)
          render_error(400, "Parameter missing": ["param is missing or the value is empty: from_id/from_type"])
        end
      else
        render_error(400, "Parameter missing": ["param is missing or the value is empty: comment"])
      end
    end

    def validate_commenter_presence
      render_error(404, "From id": ["not found"]) if @commmenter.nil? || !@commmenter.presence?
    end

    def validate_update_commenter_presence
      @commenter =  params[:comment][:from_type].classify.constantize.find_by(id: params[:comment][:from_id])
      render_error(404, "From id": ["not found"]) if @commenter.nil? || !@commenter.presence?
    end

    def set_commentable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          @class = Regexp.last_match[1]
          @commentable_type = Regexp.last_match[1].classify.safe_constantize
          @commentable = @commentable_type.find_by(id: value) if !@commentable_type.nil?
        end
      end
    end

    def set_update_commentable
      @commentable = @comment.commentable_type.classify.safe_constantize.find_by(id: @comment.commentable_id)
    end

    def validate_commentable_presence
      render_error(404, "#{@commentable_type} id": ["not found"]) if @commentable.nil? || !@commentable.presence?
    end

    # Only allow a trusted parameter "white list" through.
    def create_params
      @whitelisted = params.require(:comment).permit(:content, :from_type, :from_id)
      @whitelisted = @whitelisted.merge(commentable_id: params[@class+"_id"], commentable_type: @commentable_type)
    end

    def update_params
      @whitelisted = params.require(:comment).permit(:content, :from_type, :from_id)
    end
end
