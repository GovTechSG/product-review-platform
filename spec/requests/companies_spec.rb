# TODO: Currently the tests are written to test if ApiController works.
# More specific tests will be added in later user stories
require 'rails_helper'

RSpec.describe "Companies", type: :request do
  def login
    post oauth_sign_in_path, params: {
      grant_type: "password",
      password: "test12",
      name: "BGP"
    }.to_json, headers: { "Content-Type" => "application/json" }, as: JSON
    env ||= {}
    env['Authorization'] = "Bearer " + JSON.parse(response.body)["access_token"]
    return env
  end

  describe "GET /companies" do
    it "works! (now write some real specs)" do
      header = login
      get companies_path, params: {}, headers: header
      expect(response).to have_http_status(200)
    end
  end
end
