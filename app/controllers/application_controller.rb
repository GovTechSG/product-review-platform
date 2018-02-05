# Front facing routes inherit this
class ApplicationController < ActionController::Base
  before_action :check_host

  PLAY_ENV = '"playground"'

  def check_host

    if request.headers['location'].eql? PLAY_ENV
      Apartment::Tenant.switch!("playground")
      puts Apartment::Tenant.current
    else
      Apartment::Tenant.switch!
      puts Apartment::Tenant.current
    end
  end
end

