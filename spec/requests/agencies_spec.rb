# TODO: Currently the tests are written to test if ApiController works.
# More specific tests will be added in later user stories
require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Agencies", type: :request do
  describe "GET /agencies" do
    it "should route to agencies#index" do
      header = login
      get agencies_path, params: {}, headers: header
      expect(response).to have_http_status(200)
    end
  end
end
