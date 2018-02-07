# TODO: Currently the tests are written to test if ApiController works.
# More specific tests will be added in later user stories
require 'rails_helper'

RSpec.describe "Apidocs", type: :request do
  describe "GET /apidocs" do
    it "should route to apidocs#index" do
      get apidocs_path
      expect(response).to have_http_status(200)
    end
  end
end
