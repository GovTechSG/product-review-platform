# TODO: Currently the tests are written to test if ApiController works.
# More specific tests will be added in later user stories
require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Statistics", type: :request do
  describe "GET /statistics" do
    it "should route to statistic#show" do
      header = login
      get statistics_path, params: {}, headers: header
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /statistics/1" do
    it "should return unauthorized response" do
      @expected = unauthorized_response
      get statistics_path, params: {}, headers: nil

      expect(response).to have_http_status(401)
      expect(response.body).to look_like_json
      expect(body_as_json).to match(@expected)
    end
  end
end
