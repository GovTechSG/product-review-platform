require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Companies", type: :request do
  describe "GET /companies" do
    let(:header) { request_login }
    it "should respond with success" do
      get companies_path, params: {}, headers: header
      expect(response).to have_http_status(200)
    end

    it "should return all companies" do
      create_list(:company, 5)
      get companies_path, params: {}, headers: header
      expect(parsed_response.length).to eq(5)
    end
  end

  describe "GET /companies unauthorized" do
    it "should return unauthorized response" do
      get companies_path, params: {}, headers: nil

      expect_unauthorized
    end
  end

  describe "GET /companies/:id" do
    let(:company) { create(:company) }
    let(:header) { request_login }
    it "returns a success response" do
      get company_path(company.id), params: {}, headers: header
      expect(response).to be_success
    end

    it "returns data of a single company" do
      get company_path(company.id), params: {}, headers: header
      expect_show_response
    end

    it "returns not found if the company does not exist" do
      get company_path(0), params: {}, headers: header
      expect_not_found
    end
  end

  describe "GET /companies/:id unauthorized" do
    it "returns unauthorized response" do
      get company_path(0), params: {}, headers: nil
      expect_unauthorized
    end
  end
end
