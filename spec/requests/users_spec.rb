require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    it "should route to users#index" do
      header = request_login
      get users_url, params: {}, headers: header
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /users" do
    it "should return unauthorized response" do
      @expected = unauthorized_response
      get users_url, params: {}, headers: nil

      expect(response).to have_http_status(401)
      expect(response.body).to look_like_json
      expect(parsed_response).to match(@expected)
    end
  end
end
