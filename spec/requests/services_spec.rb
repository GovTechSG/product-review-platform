# TODO: Currently the tests are written to test if ApiController works.
# More specific tests will be added in later user stories
require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Services", type: :request do
  describe "GET /services/1" do
    it "should route to services#show" do
      header = login
      get service_path('1'), params: {}, headers: header
      expect(response).to have_http_status(200)
    end
  end
end
