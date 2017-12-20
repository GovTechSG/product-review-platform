class ReviewsController < ApplicationController
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

    render json: @reviews, methods: [:agency, :likes_count, :comments_count]
  end

  # GET /reviews/1
  def show
    render json: @review, methods: [:agency, :likes_count, :comments_count]
  end

  # POST /products/:product_id/reviews
  # POST /services/:service_id/reviews
  def create
    # Store review_params in a temp variable to avoid
    # repeatedly calling the method
    whitelisted = review_params
    params = {
      score: whitelisted[:score],
      content: whitelisted[:content],
      agency_id: whitelisted[:agency_id]
    }
    if whitelisted[:product_id].present?
      params[:reviewable_id] = whitelisted[:product_id]
      params[:reviewable_type] = "Product"
    elsif whitelisted[:service_id].present?
      params[:reviewable_id] = whitelisted[:service_id]
      params[:reviewable_type] = "Service"
    else
      render_bad_request("No product_id or service_id specified")
      return
    end
    @review = Review.new(params)

    if @review.save
      render json: @review, status: :created, location: @review
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reviews/1
  def update
    if @review.update(review_params)
      render json: @review
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  # DELETE /reviews/1
  def destroy
    @review.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def review_params
      params.require(:review).permit(:score, :content, :product_id, :service_id, :agency_id)
    end
end
