# Front facing routes inherit this
class ApplicationController < ActionController::Base
  include RenderErrors
end
