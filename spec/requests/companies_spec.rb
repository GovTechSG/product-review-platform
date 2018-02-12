require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Companies", type: :request do
  describe "GET /companies" do
    it "should respond with success" do
      header = request_login
      get companies_path, params: {}, headers: header
      expect(response).to have_http_status(200)
    end

    it "should return all companies" do
      create_list(:company, 5)
      header = request_login
      get companies_path, params: {}, headers: header
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.length).to eq(5)
    end
  end

  describe "GET /companies" do
    it "should return unauthorized response" do
      @expected = unauthorized_response
      get companies_path, params: {}, headers: nil

      expect(response).to have_http_status(401)
      expect(response.body).to look_like_json
      expect(body_as_json).to match(@expected)
    end
  end
end
