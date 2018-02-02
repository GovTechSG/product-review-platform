# TODO: Currently the tests are written to test if ApiController works.
# More specific tests will be added in later user stories
require 'rails_helper'

RSpec.describe "Services", type: :request do
  describe "GET /services/1" do
    it "works! (now write some real specs)" do
      get service_path('1')
      expect(response).to have_http_status(401)
    end
  end
end
