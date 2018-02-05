class ReviewsController < ApiController
  include SwaggerDocs::Reviews

  before_action :set_review, only: [:show, :update, :destroy]

  # GET /products/:product_id/reviews
  # GET /services/:service_id/reviews
  def index
    @reviews = []
    if params[:product_id].present?
      @reviews = Product.find(params[:product_id]).reviews
    elsif params[:service_id].present?
      @reviews = Service.find(params[:service_id]).reviews
    else
      render_bad_request("No product_id or service_id specified")
      return
    end

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
      render_bad_request("No product_id or service_id specified")
      return
    end
    reviewable = params[:product_id].present? ? Product.find(params[:product_id]) : Service.find(params[:service_id])
    @review = Review.new(whitelisted)
    # Update aggregate score of associated vendor company
    company = add_company_score(reviewable.company, whitelisted[:score])

    if @review.save && company.save
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
    if whitelisted[:score]
      # Update aggregate score of associated vendor company
      company = update_company_score(@review.reviewable.company, @review.score, whitelisted[:score])
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
    @review.destroy && company.save
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

    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
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
