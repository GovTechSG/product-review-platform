# API routes go here
class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include RenderErrors
end

# Front-end routes go here
class BaseController < ActionController::Base
  
end
