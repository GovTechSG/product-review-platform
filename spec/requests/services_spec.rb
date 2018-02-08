# TODO: Currently the tests are written to test if ApplicationController works.
# More specific tests will be added in later user stories
require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Services", type: :request do
  describe "GET /services/:id" do
    it "should route to services#show" do
      header = request_login

      service = create(:service)
      get service_path(service.id), params: {}, headers: header
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /services/:id" do
    it "should return unauthorized response" do
      @expected = unauthorized_response
      service = create(:service)
      get service_path(service.id), params: {}, headers: nil

      expect(response).to have_http_status(401)
      expect(response.body).to look_like_json
      expect(body_as_json).to match(@expected)
    end
  end
end
