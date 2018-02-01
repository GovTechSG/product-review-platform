class ApplicationController < ActionController::API
  before_action :check_host
  include DeviseTokenAuth::Concerns::SetUserByToken
  include RenderErrors

  PLAY_ENV = '"playground"'

  def check_host
    puts "Where is it from: " , request.headers['location']
    if request.headers['location'].eql? PLAY_ENV
      Apartment::Tenant.switch!("playground")
      puts Apartment::Tenant.current
    else
      Apartment::Tenant.switch!
      puts Apartment::Tenant.current
    end
  end
end

