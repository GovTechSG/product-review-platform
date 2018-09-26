class ProductsController < ApplicationController
  include SwaggerDocs::Products
  before_action -> { doorkeeper_authorize! :read_only, :read_write }, only: [:index, :show]
  before_action only: [:create, :update, :destroy, :search] do
    doorkeeper_authorize! :read_write, :write_only
  end
  before_action :set_product, only: [:show, :update, :destroy]
  before_action :validate_product_presence, only: [:show, :update, :destroy]
  before_action :set_company, only: [:index, :create]
  before_action :validate_company_presence, only: [:index, :create]
  before_action :validate_company_uen_name, only: [:search]
  before_action :set_searched_company, only: [:search]
  after_action only: [:index] { set_pagination_header(CompanyReviewable.kept.where(company_id: @company.id, reviewable_type: "Product").map(&:reviewable)) }

  # GET /companies/:company_id/products
  def index
    @products = CompanyReviewable.kept.where(company_id: @company.id, reviewable_type: "Product").map(&:reviewable)

    render json: paginator(@products), methods: [:reviews_count, :aggregate_score], has_type: false
  end

  # GET /products/1
  def show
    render json: @product, methods: [:reviews_count, :aggregate_score], has_type: false
  end

  # POST /companies/:company_id/products
  def create
    @product = Product.new(product_params)
    if !@product.save
      render json: @product.errors.messages, status: :unprocessable_entity
      return
    end
    @product.reload
    company_reviewable = CompanyReviewable.new(reviewable: @product, company: @company)
    if company_reviewable.save
      render json: @product, status: :created, location: @product, has_type: false
    else
      render json: company_reviewable.errors.messages, status: :unprocessable_entity
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

  # POST /product/product_name
  def search
    validate_search_params
    return if performed?
    validate_vendor_uen_name
    @searched_vendor = @searched_vendor.nil? ? create_vendor : @searched_vendor
    @product = Product.kept.find_by(name: params[:product_name])

    create_product if @product.nil?
    create_company_reviewable_if_not_exists
    render json: { 'product_id': @product.hashid } if !performed?
  end

  private

  def create_company_reviewable_if_not_exists
    if CompanyReviewable.find_by(reviewable: @product, company: @searched_vendor).blank?
      company_reviewable = CompanyReviewable.new(reviewable: @product, company: @searched_vendor)
      render json: company_reviewable.errors.messages, status: :unprocessable_entity if !company_reviewable.save
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find_by_hashid(params[:id])
  end

  def create_product
    @product = Product.new(name: params[:product_name], description: params[:product][:description])
    if !@product.save!
      render json: @product.errors.messages, status: :unprocessable_entity
      return
    end
  rescue ActiveRecord::RecordNotUnique
    search
  end

  def validate_product_presence
    render_error(404, "#{I18n.t('product.key_id')}": [I18n.t('general_error.not_found')]) if @product.nil? || !@product.presence?
  end

  def set_company
    @company = Company.find_by_hashid(params[:company_id])
  end

  def set_searched_company
    @searched_company = create_company if @searched_company.nil?
    if @searched_company.errors.blank?
    else
      render json: @searched_company.errors.messages, status: :unprocessable_entity
    end
  end

  def validate_company_uen_name
    @searched_company = Company.kept.uen_query_sanitizer(params[:company][:uen].downcase.lstrip.strip)
    @searched_company = Company.kept.name_query_sanitizer(params[:company][:name].downcase.lstrip.strip) if @searched_company.nil? || @searched_company.uen.blank?
  end

  def create_company
    company = Company.new(name: params[:company][:name], uen: params[:company][:uen], description: params[:company][:description])
    company.set_image!(@image) if params[:company][:name].present?
    company.errors.blank? && company.save
    company
  end

  def validate_vendor_uen_name
    @searched_vendor = Company.kept.uen_query_sanitizer(params[:vendor_uen].to_s.downcase)
    @searched_vendor = Company.kept.name_query_sanitizer(params[:vendor_name].downcase) if @searched_vendor.nil? || @searched_vendor.uen.blank?
  end

  def create_vendor
    vendor = Company.new(name: params[:vendor_name], uen: params[:vendor_uen], description: "")
    vendor.set_image!(@image) if params[:vendor_name].present?
    vendor.errors.blank? && vendor.save
    vendor
  end

  def validate_company_presence
    render_error(404, "#{I18n.t('company.key_id')}": [I18n.t('general_error.not_found')]) if @company.nil? || !@company.presence?
  end

  # Only allow a trusted parameter "white list" through.
  def product_params
    params.require(:product).permit(:name, :description, :vendor_uen, :vendor_name)
  end

  def validate_search_params
    render_error(404, "Vendor name or company": [I18n.t('general_error.not_found')]) if params[:vendor_name].nil? || params[:vendor_uen].nil?
  end
end
