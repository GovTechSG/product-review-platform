class CompaniesController < ApplicationController
  include SwaggerDocs::Companies
  before_action :doorkeeper_authorize!
  before_action :set_company, only: [:show, :update, :destroy]
  before_action :set_company_by_company_id, only: [:clients]
  before_action :validate_company_presence, only: [:show, :update, :destroy, :clients]
  before_action :set_industry, only: [:create, :update]
  before_action :validate_industry_presence, only: [:create, :update]
  before_action :validate_search_inputs, only: [:search]

  after_action only: [:index] { set_pagination_header(Company.kept) }
  after_action only: [:clients] { set_pagination_header(@company.clients.kept) }

  # GET /companies
  def index
    @companies = Company.kept.page params[:page]

    render json: @companies, methods: [:aspects], has_type: false
  end

  # GET /companies/vendor_listings
  def vendor_listings
    set_sort

    handle_vendor_get

    if !performed?
      companies = @companies.blank? ? [].to_json : ActiveModel::SerializableResource.new(@companies, each_serializer: VendorListingSerializer).to_json
      company_count = @results_array.length

      render json: {
        companies: JSON.parse(companies),
        count: company_count
      }
    end
  end

  # GET /companies/:company_id/clients
  def clients
    render json: (@company.clients.page params[:page]), has_type: false
  end

  # GET /companies/1
  def show
    render json: @company, methods: [:aspects], has_type: false
  end

  # POST /companies
  def create
    convert_hashids
    @company = Company.new(@whitelisted)
    @company.set_image!(@image) if @whitelisted[:name].present?
    if @company.errors.blank? && @company.save
      render json: @company, status: :created, location: @company, has_type: false
    else
      render json: @company.errors.messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/1
  def update
    convert_hashids
    if !@image.nil?
      @company.assign_attributes(@whitelisted)
      @company.set_image!(@image) if @company.valid?
    end
    if @company.errors.blank? && @company.update(@whitelisted)
      render json: @company, has_type: false
    else
      render json: @company.errors.messages, status: :unprocessable_entity
    end
  end

  # DELETE /companies/1
  def destroy
    @company.discard
  end

  # POST /company/company_uen
  def search
    # check if company exist by UEN
    company = Company.kept.find_by(uen: params[:user][:uen])
    if company.nil?
      # create company if not found
      company = create_company
    end
    render json: { 'company_id': company.hashid }
  end

  private

    def create_company
      company = Company.new(name: params[:user][:name], uen: params[:user][:uen], description: params[:user][:description])
      company.set_image!(@image) if params[:user][:name].present?
      company.save if company.errors.blank?
      company
    end

    def set_sort
      @sort =
        if vendor_listing_valid_options.include? params[:sort_by]
          params[:sort_by]
        else
          vendor_listing_valid_options.first
        end
    end

    def handle_vendor_get
      @results_array = Company.send("sort", @sort)
      handle_vendor_search if params[:search].present?
      handle_vendor_filter if params[:filter].present?

      @companies = Kaminari.paginate_array(@results_array).page(params[:page]).per(params[:per_page])
    end

    def handle_vendor_search
      @results_array = Company
                       .ransack(name_cont: params[:search])
                       .result(distinct: true).kept
      @results_array = handle_vendor_sort
    end

    def handle_vendor_sort
      case @sort
      when 'best_ratings'
        @results_array = @results_array.sort_by(&:ratings).reverse!
      when 'newly_added'
        @results_array = @results_array.order(created_at: :desc)
      end
    end

    def handle_vendor_filter
      initialize_filter_vars
      get_filters
      filter_vendors
    end

    def initialize_filter_vars
      @filter_hash = {}
      @filter_hash["grants"] = []
      @filter_hash["industries"] = []
      @filters = params[:filter].to_s.split(',')
    end

    def get_filters
      @filters.each do |filter|
        filter_set = filter.split(':', 2)
        if filter_set.length != 2
          render_error(400, "#{I18n.t('general_error.invalid_filter')}": [I18n.t('general_error.invalid_filter_value')])
          break
        end
        validate_filter_method filter_set[0]
        break if performed?
        @filter_hash[filter_set[0]].push(filter_set[1])
      end
    end

    def filter_vendors
      @results_array.delete_if do |company|
        vendor_match_filter company
      end
    end

    def vendor_match_filter(company)
      @filter_hash.each do |filter, values|
        return false if company.send(filter).find_by_hashid(values).present?
      end
        true
    end

    def validate_filter_method(filter_method)
      render_error(400, "#{filter_class}": [I18n.t('general_error.not_a_class')]) if !(valid_filter_methods.include? filter_method)
    end

    def valid_filter_methods
      @filter_hash.keys
    end

    # Use callbacks to share common setup or constraints between actions.
    def validate_search_inputs
      if !params[:user].nil? && (params[:user][:uen].nil? || params[:user][:name].nil? || params[:user][:description].nil?)
        render_error(400, "#{I18n.t('general_error.params_missing_key')}": [I18n.t('general_error.params_missing_value', model: "user")])
      end
    end

    def set_company
      @company = Company.find_by_hashid(params[:id])
    end

    def set_company_by_company_id
      @company = Company.find_by_hashid(params[:company_id])
    end

    def validate_company_presence
      render_error(404, "#{I18n.t('company.key_id')}": [I18n.t('general_error.not_found')]) if @company.nil? || !@company.presence?
    end

    def set_industry
      if params[:company].present?
        @industry = Industry.find_by_hashid(params[:company][:industry_ids]) if params[:company][:industry_ids].present?
      else
        render_error(400, "#{I18n.t('general_error.params_missing_key')}": [I18n.t('general_error.params_missing_value', model: "company")])
      end
    end

    def validate_industry_presence
      if params[:company][:industry_ids].present?
        render_error(404, "#{I18n.t('industry.key_id')}": [I18n.t('general_error.not_found')]) if @industry.nil? || !@industry.presence?
      end
    end

    # Only allow a trusted parameter "white list" through.
    def company_params
      @image = params[:company][:image] if params[:company].present? && params[:company][:image].present?
      @whitelisted = params.require(:company).permit(:name, :uen, :description, :phone_number, :url, industry_ids: [])
    end

    def convert_hashids
      company_params
      if @whitelisted["industry_ids"]
        industries = Industry.find(@whitelisted["industry_ids"])
        @whitelisted["industry_ids"] = industries.map(&:id)
      end
    end

    def vendor_listing_valid_options
      ["best_ratings", "newly_added"]
    end

    def fuzzy_search_params
      params.require(:search).permit(:key, :value)
    end
end
