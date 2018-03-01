class ReviewsController < ApplicationController
  include SwaggerDocs::Reviews
  before_action :doorkeeper_authorize!
  before_action :set_review, only: [:show, :update, :destroy]
  before_action :validate_review_presence, only: [:show, :update, :destroy]
  before_action :set_reviwable, only: [:index, :create]
  before_action :validate_reviewable_presence, only: [:index, :create]
  before_action :validate_score_type, only: [:create, :update]

  # GET /products/:product_id/reviews
  # GET /services/:service_id/reviews
  def index
    @reviews = @reviewable.reviews.where(discarded_at: nil)

    render json: @reviews, methods: [:company, :likes_count, :comments_count, :strengths]
  end

  # GET /reviews/1
  def show
    render json: @review, methods: [:company, :likes_count, :comments_count, :strengths]
  end

  # POST /products/:product_id/reviews
  # POST /services/:service_id/reviews
  def create
    # Store create_params in a temp variable to avoid
    # repeatedly calling the method
    whitelisted = create_params
    if whitelisted.nil?
      render_error(400, "No product_id or service_id specified")
      return
    end
    @review = Review.new(whitelisted)
    # Update aggregate score of associated vendor company
    company = add_company_score(@reviewable.company, @score) if @score

    if @review.save && (company.nil? || company.save)
      render json: @review, status: :created, location: @review
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reviews/1
  def update
    company = nil
    # Store update_params in a temp variable to avoid
    # repeatedly calling the method
    whitelisted = update_params
    if !@score.nil?
      # Update aggregate score of associated vendor company
      company = update_company_score(@review.reviewable.company, @review.score, @score)
    end
    if @review.update(whitelisted) && (company.nil? || company.save)
      render json: @review
    else
      render json: @review.errors, status: :unprocessable_entity
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
          render_error(422, "Score is not a number")
        end
      end
    rescue ArgumentError
      render_error(422, "Score is not a number")
    end

    def set_reviwable
      if params[:product_id].present?
        @reviewable = Product.find_by(id: params[:product_id])
      elsif params[:service_id].present?
        @reviewable = Service.find_by(id: params[:service_id])
      else
        render_error(400, "No product_id or service_id specified")
      end
    end

    def validate_reviewable_presence
      render_error(404, "Product/service id not found") if @reviewable.nil? ||
                                                           @reviewable.discarded? || 
                                                           @reviewable.company.discarded?
    end

    def validate_review_presence
      render_error(404, "Review id not found") if @review.nil? ||
                                                  @review.discarded? ||
                                                  @review.reviewable.discarded? ||
                                                  @review.reviewable.company.discarded?
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find_by(id: params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def create_params
      whitelisted = params.require(:review).permit(:score, :content, :company_id, :strengths => [])
      if params[:product_id].present?
        whitelisted = whitelisted.merge(reviewable_id: params[:product_id], reviewable_type: "Product")
      elsif params[:service_id].present?
        whitelisted = whitelisted.merge({reviewable_id: params[:service_id], reviewable_type: "Service"})
      else return nil
      end
      whitelisted
    end

    def update_params
      params.require(:review).permit(:score, :content, :strengths => [])
    end
end
