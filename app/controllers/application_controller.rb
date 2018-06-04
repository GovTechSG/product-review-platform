# Front facing routes inherit this
class ApplicationController < ActionController::Base
  include RenderErrors

  rescue_from ActiveRecord::RecordNotFound do |error|
    render_error(404, "Record not found": [error.message])
  end

  rescue_from ActiveRecord::RecordNotUnique do
    render_error(422, object: ["already exists"])
  end

  rescue_from ActionController::ParameterMissing do |error|
    render_error(400, "#{I18n.t('general_error.params_missing_key')}": [error.message])
  end

  rescue_from ActionController::RoutingError do |error|
    render_error(400, "Bad request": [error.message])
  end

  def set_pagination_header(data)
    headers["Total"] = data.count
    headers["Per-Page"] = data.page.limit_value
  end

  protected

  def set_search
    validate_search_params_presence
    get_search_object if !performed?
    get_search_attribute if !performed?
  end

  private

  def get_search_object
    @search_object = @search_params[:search_object].classify.safe_constantize
    render_error(400, "#{@search_params[:search_object]}": [I18n.t('general_error.not_a_class')]) if @search_object.nil?
  end

  def get_search_attribute
    @search_attribute = @search_params[:search_attribute] if @search_object.column_names.include? @search_params[:search_attribute]
    render_error(400, "#{@search_params[:search_attribute]}": [I18n.t('general_error.not_a_column', key: @search_params[:search_attribute])]) if @search_attribute.nil?
  end

  def validate_search_params_presence
    @search_params = JSON.parse(params[:search]).with_indifferent_access
    if @search_params[:search_object].blank? ||
       @search_params[:search_attribute].blank?
      render_error(400, "#{I18n.t('general_error.params_missing_key')}": [I18n.t('general_error.params_missing_value', model: "search")])
    end
  end
end