class ProductsController < ApplicationController
  include SwaggerDocs::Products
  before_action :doorkeeper_authorize!
  before_action :set_product, only: [:show, :update, :destroy]
  before_action :validate_product_presence, only: [:show, :update, :destroy]
  before_action :set_company, only: [:index, :create]
  before_action :validate_company_presence, only: [:index, :create]

  after_action only: [:index] { set_pagination_header(Product.kept.where(company_id: params[:company_id])) }

  # GET /companies/:company_id/products
  def index
    @products = params[:page] == 'all' ? Product.kept.where(company_id: @company.id) : Product.kept.where(company_id: @company.id).page(params[:page])

    render json: @products, methods: [:reviews_count, :aggregate_score], has_type: false
  end

  # GET /products/1
  def show
    render json: @product, methods: [:reviews_count, :aggregate_score, :company_name], has_type: false
  end

  # POST /companies/:company_id/products
  def create
    @product = Product.new(product_params.merge(company_id: @company.id))

    if @product.save
      render json: @product, status: :created, location: @product, has_type: false
    else
      render json: @product.errors.messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      render json: @product, has_type: false
    else
      render json: @product.errors.messages, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.discard
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find_by_hashid(params[:id])
    end

    def validate_product_presence
      render_error(404, "#{I18n.t('product.key_id')}": [I18n.t('general_error.not_found')]) if @product.nil? || !@product.presence?
    end

    def set_company
      @company = Company.find_by_hashid(params[:company_id])
    end

    def validate_company_presence
      render_error(404, "#{I18n.t('company.key_id')}": [I18n.t('general_error.not_found')]) if @company.nil? || !@company.presence?
    end

    # Only allow a trusted parameter "white list" through.
    def product_params
      params.require(:product).permit(:name, :description)
    end
end
