# TODO: Currently the tests are written to test if ApiController works.
# More specific tests will be added in later user stories
require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Companies", type: :request do
  describe "GET /companies" do
    it "should route to companies#index" do
      header = login
      get companies_path, params: {}, headers: header
      expect(response).to have_http_status(200)
    end
  end
end
