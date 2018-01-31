# API routes inherit this
class ApiController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  include RenderErrors
end
