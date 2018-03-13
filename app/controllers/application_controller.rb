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
    render_error(400, "Parameter missing": [error.message])
  end

  rescue_from ActionController::RoutingError do |error|
    render_error(400, "Bad request": [error.message])
  end
end
