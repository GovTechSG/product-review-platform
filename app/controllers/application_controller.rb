# Front facing routes inherit this
class ApplicationController < ActionController::Base
  include RenderErrors

  rescue_from ActiveRecord::RecordNotFound do |error|
    render_error(404, error)
  end

  rescue_from ActiveRecord::RecordNotUnique do |_error|
    render_error(422, "Object already exists")
  end

  rescue_from ActionController::ParameterMissing do |error|
    render_error(400, error)
  end

  rescue_from ActionController::RoutingError do |error|
    render_error(404, error)
  end
end
