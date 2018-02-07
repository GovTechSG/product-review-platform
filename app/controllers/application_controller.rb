# Front facing routes inherit this
class ApplicationController < ActionController::Base
  before_action :check_host

  PLAY_ENV = '"playground"'.freeze

  def check_host
    if request.headers['location'].eql? PLAY_ENV
      Apartment::Tenant.switch!("playground")
    else
      Apartment::Tenant.switch!
    end
  end
end

