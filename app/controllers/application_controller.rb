class ApplicationController < ActionController::API
  before_action :check_host
  include DeviseTokenAuth::Concerns::SetUserByToken
  include RenderErrors

  def check_host
    puts "Where is it from: " , request.headers['location']
    if request.headers['location'] == "playground"
      Apartment::Tenant.switch!("playground")
    else
      Apartment::Tenant.switch!
    end
  end
end

