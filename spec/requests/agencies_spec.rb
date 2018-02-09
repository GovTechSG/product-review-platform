require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Agencies", type: :request do
  describe "GET /agencies" do
    it "should route to agencies#index" do
      header = request_login
      get agencies_url, params: {}, headers: header
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /agencies" do
    it "should return unauthorized response" do
      @expected = unauthorized_response
      get agencies_url, params: {}, headers: nil

      expect(response).to have_http_status(401)
      expect(response.body).to look_like_json
      expect(body_as_json).to match(@expected)
    end
  end
end
