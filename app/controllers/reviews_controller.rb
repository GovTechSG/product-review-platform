class ReviewsController < ApplicationController
  include SwaggerDocs::Reviews
  before_action :doorkeeper_authorize!
  before_action :set_review, only: [:show, :update, :destroy]
  before_action :validate_review_presence, only: [:show, :update, :destroy]
  before_action :set_company, only: [:create]
  before_action :validate_company_presence, only: [:create]
  before_action :set_grant, only: [:create]
  before_action :validate_grant_presence, only: [:create]
  before_action :set_reviewable, only: [:index, :create]
  before_action :validate_reviewable_presence, only: [:index, :create]
  before_action :validate_score_type, only: [:create, :update]
  before_action :validate_set_create_from, only: [:create]
  before_action :validate_set_update_from, only: [:update]

  # GET /products/:product_id/reviews
  # GET /services/:service_id/reviews
  def index
    @reviews = @reviewable.reviews.kept
    render json: @reviews, methods: [:company, :likes_count, :comments_count, :strengths], reviewable: @reviewable
  end

  # GET /reviews/1
  def show
    render json: @review, methods: [:company, :likes_count, :comments_count, :strengths], reviewable: @review.reviewable
  end

  # POST /products/:product_id/reviews
  # POST /services/:service_id/reviews
  def create
    @review = Review.new(@whitelisted)
    # Update aggregate score of associated vendor company
    company = add_company_score(@reviewable.company, @score) if @score

    if @review.save && (company.nil? || company.save)
      render json: @review, status: :created, location: @review, reviewable: @reviewable
    else
      render json: @review.errors.messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reviews/1
  def update
    company = nil
    # Store update_params in a temp variable to avoid
    # repeatedly calling the method
    if !@score.nil?
      # Update aggregate score of associated vendor company
      company = update_company_score(@review.reviewable.company, @review.score, @score)
    end
    if @review.update(@whitelisted) && (company.nil? || company.save)
      render json: @review, reviewable: @review.reviewable
    else
      render json: @review.errors.messages, status: :unprocessable_entity
    end
  end

  # DELETE /reviews/1
  def destroy
    # Update aggregate score of associated vendor company
    company = subtract_company_score(@review.reviewable.company, @review.score)
    @review.discard && company.save
  end

  private
    def add_company_score(company, score)
      company.aggregate_score = company.add_score(score)
      company
    end

    def update_company_score(company, old_score, updated_score)
      company.aggregate_score = company.update_score(old_score, updated_score)
      company
    end

    def subtract_company_score(company, score)
      company.aggregate_score = company.subtract_score(score)
      company
    end

    def validate_score_type
      score_param = params.require(:review).permit(:score)[:score]
      if score_param
        if score_param.is_a? String
          @score = Float(score_param)
        elsif score_param.is_a? Numeric
          @score = score_param
        else
          render_error(422, "Score": ["is not a number"])
        end
      end
    rescue ArgumentError
      render_error(400, "Score": ["is not a number"])
    end

    def set_reviewable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          @reviewable_type = Regexp.last_match[1].classify.safe_constantize
          @reviewable = @reviewable_type.find_by(id: value) if !@reviewable_type.nil?
        end
      end
    end

    def validate_reviewable_presence
      render_error(404, "#{@reviewable_type} id": ["not found"]) if @reviewable.nil? || !@reviewable.presence?
    end

    def validate_review_presence
      render_error(404, "Review id": ["not found"]) if @review.nil? || !@review.presence?
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find_by(id: params[:id])
    end

    def set_company
      if params[:review].present? && params[:review][:from_id].present?
        @company = Company.find_by(id: params[:review][:from_id])
      else
        render_error(400, "From id": ["not provided"])
      end
    end

    def validate_company_presence
      render_error(404, "From id": ["not found"]) if @company.nil? || !@company.presence?
    end

    def set_grant
      if params[:review][:grant_id].present?
        @grant = Grant.find_by(id: params[:review][:grant_id])
      else
        render_error(400, "Grant id": ["not provided"])
      end
    end

    def validate_grant_presence
      render_error(404, "Grant id": ["not found"]) if @grant.nil? || !@grant.presence?
    end

    def validate_set_create_from
      type = params[:review][:from_type].classify.safe_constantize
      if type != nil
        if type.superclass.name != "Reviewer"
          render_error(422, "From type": ["is invalid"])
        else
          # Store create_params in a temp variable to avoid
          # repeatedly calling the method
          @whitelisted = create_params
          if @whitelisted.nil?
            render_error(400, "Product/Service id": ["not specified"])
            return
          end
          @whitelisted["reviewer_id"] = @whitelisted["from_id"]
          @whitelisted.delete("from_id")
          @whitelisted["reviewer_type"] = @whitelisted["from_type"].classify.safe_constantize
          @whitelisted.delete("from_type")
        end
      else
        render_error(422, "From type": ["is invalid"])
      end
    end

    def validate_set_update_from
      type = nil
      if params[:review].present? && params[:review][:from_type].present?
        type = params[:review][:from_type].classify.safe_constantize
        if type != nil
          if type.superclass.name != "Reviewer"
            render_error(422, "From type": ["is invalid"])
          else
            # Store create_params in a temp variable to avoid
            # repeatedly calling the method
            @whitelisted = update_params
            if @whitelisted.nil?
              render_error(400, "Review id": ["not specified"])
              return
            end
            @whitelisted["reviewer_id"] = @whitelisted["from_id"]
            @whitelisted.delete("from_id")
            @whitelisted["reviewer_type"] = @whitelisted["from_type"].classify.safe_constantize
            @whitelisted.delete("from_type")
          end
        end
      else
        @whitelisted = update_params
        if @whitelisted.nil?
          render_error(400, "Review id": ["not specified"])
          return
        end
      end
    end

    # Only allow a trusted parameter "white list" through.
    def create_params
      @whitelisted = params.require(:review).permit(:score, :content, :from_id, :from_type, :grant_id, :strengths => [])
      if params[:product_id].present?
        @whitelisted = @whitelisted.merge(reviewable_id: params[:product_id], reviewable_type: "Product")
      elsif params[:service_id].present?
        @whitelisted = @whitelisted.merge({reviewable_id: params[:service_id], reviewable_type: "Service"})
      else return nil
      end
    end

    def update_params
      params.require(:review).permit(:score, :content, :from_id, :from_type, :grant_id, :strengths => [])
    end
end
