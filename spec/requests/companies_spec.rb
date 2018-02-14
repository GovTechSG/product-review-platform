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

  describe "POST /companies" do
    let(:company) { build(:company) }
    let(:header) { request_login }
    it "returns a success response" do
      post companies_path, params: { company: company.as_json }, headers: header
      expect(response.status).to eq(201)
    end

    it "returns data of the single created company" do
      post companies_path, params: { company: company.as_json }, headers: header
      expect_show_response
    end

    it "returns Unprocessable Entity if company is not valid" do
      company.name = ""
      post companies_path, params: { company: company.as_json }, headers: header
      expect(response.status).to eq(422)
    end
  end

  describe "POST /companies unauthorized" do
    it "returns an unauthorized response" do
      post companies_path, params: { company: {} }, headers: nil
      expect_unauthorized
    end
  end

  describe "PATCH /company/:id" do
    let(:company) { create(:company) }
    let(:header) { request_login }
    it "returns a success response" do
      patch company_path(company.id), params: { company: company.as_json }, headers: header
      expect(response.status).to eq(200)
    end

    it "returns data of the single updated company" do
      updated_company = build(:company)
      patch company_path(company.id), params: { company: updated_company.as_json }, headers: header
      company.reload
      expect(company.attributes.except('id', 'created_at', 'updated_at')).to match(updated_company.attributes.except('id', 'created_at', 'updated_at'))
    end

    it "returns Unprocessable Entity if company is not valid" do
      original_company = company
      patch company_path(company.id), params: { company: Company.new(aggregate_score: 6).as_json, id: company.id }, headers: header
      company.reload
      expect(company).to match(original_company)
      expect(response.status).to eq(422)
      expect(parsed_response.keys).to contain_exactly('name', 'UEN', 'description', 'aggregate_score')
    end
  end

  describe "PATCH #update", authorized: false do
    it "returns an unauthorized response" do
      patch company_path(0), params: { company: {}, id: 0 }
      expect_unauthorized
    end
  end
end
