# TODO: Currently the tests are written to test if ApiController works. 
# More specific tests will be added in later user stories
require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  describe "GET /reviews/1" do
    it "works! (now write some real specs)" do
      get review_path('1')
      expect(response).to have_http_status(200)
    end
  end
end
