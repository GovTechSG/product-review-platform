# Front-end routes go here
class ApplicationController < ApiController::Base
end

# API routes go here
class ApiController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include RenderErrors
end