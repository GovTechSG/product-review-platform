# TODO: Currently the tests are written to test if ApiController works.
# More specific tests will be added in later user stories
require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Statistics", type: :request do
  describe "GET /statistics" do
    it "should route to statistic#show" do
      header = login
      get statistics_path('1'), params: {}, headers: header
      expect(response).to have_http_status(200)
    end
  end
end
