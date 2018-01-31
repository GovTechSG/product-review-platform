# app/controllers/api_controller.rb
class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include RenderErrors
end

class BaseController < ActionController::Base
end
