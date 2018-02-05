# TODO: Currently the tests are written to test if ApiController works. 
# More specific tests will be added in later user stories
require 'rails_helper'

RSpec.describe "Statistics", type: :request do
  describe "GET /statistics" do
    it "works! (now write some real specs)" do
      get statistics_path('1')
      expect(response).to have_http_status(401)
    end
  end
end
