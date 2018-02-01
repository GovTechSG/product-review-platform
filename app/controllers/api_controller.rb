# API routes inherit this
class ApiController < ActionController::Base
  include RenderErrors
end
