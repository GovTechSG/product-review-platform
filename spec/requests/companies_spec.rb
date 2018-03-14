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

    it "should not return discarded companies" do
      create_list(:company, 5)
      Company.first.discard
      get companies_path, params: {}, headers: header
      expect(parsed_response.length).to eq(4)
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

    it "returns a not found response if the company is deleted" do
      company.discard
      get company_path(company.id), params: {}, headers: header
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
    let(:industry) { create(:industry) }
    let(:header) { request_login }
    it "returns a success response" do
      post companies_path, params: { company: company.as_json.merge(industry_ids: [industry.id]) }, headers: header
      expect(response.status).to eq(201)
    end

    it "returns data of the single created company" do
      post companies_path, params: { company: company.as_json }, headers: header
      expect_show_response
    end

    it "returns Unprocessable Entity if company is not valid" do
      company.name = ""
      post companies_path, params: { company: company.as_json.merge(industry_ids: [industry.id]) }, headers: header
      expect(response.status).to eq(422)
    end

    it "renders a 422 error for duplicate UEN" do
      dupcompany = build(:company)
      dupcompany.UEN = company.UEN
      dupcompany.save
      post companies_path, params: { company: company.as_json.merge(industry_ids: [industry.id]) }, headers: request_login
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to eq('application/json')
    end

    it "return 404 when industry ID is invalid" do
      post companies_path, params: { company: company.as_json.merge(industry_ids: [0]) }, headers: request_login
      expect_not_found
    end

    it "return 404 when industry ID is deleted" do
      industry.discard
      post companies_path, params: { company: company.as_json.merge(industry_ids: [industry.id]) }, headers: request_login
      expect_not_found
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
    let(:industry) { create(:industry) }
    let(:header) { request_login }
    it "returns a success response" do
      patch company_path(company.id), params: { company: company.as_json.merge(industry_ids: [industry.id]) }, headers: header
      expect(response.status).to eq(200)
    end

    it "returns data of the single updated company" do
      updated_company = build(:company)
      patch company_path(company.id), params: { company: updated_company.as_json.merge(industry_ids: [industry.id]) }, headers: header
      company.reload
      expect(company.attributes.except('id', 'created_at', 'updated_at', 'aggregate_score')).to match(updated_company.attributes.except('id', 'created_at', 'updated_at', 'aggregate_score'))
    end

    it "returns Unprocessable Entity if company is not valid" do
      original_company = company
      another_company = create(:company)
      patch company_path(company.id), params: { company: attributes_for(:company, UEN: another_company.UEN).as_json.merge(industry_ids: [industry.id]), id: company.id }, headers: header
      company.reload
      expect(company).to match(original_company)
      expect(response.status).to eq(422)
    end

    it "returns not found if company id is not valid" do
      patch company_path(0), params: { company: company.as_json }, headers: header
      expect(response.status).to eq(404)
    end

    it "returns a not found response if the company is deleted" do
      original_company = company
      original_company.discard
      patch company_path(company.id), params: { company: company.as_json }, headers: header
      expect(company).to match(original_company)
      expect(response.status).to eq(404)
    end

    it "renders a 422 error for duplicate UEN" do
      dupcompany = build(:company)
      dupcompany.save
      company.UEN = dupcompany.UEN
      patch company_path(company.id), params: { company: company.as_json.merge(industry_ids: [industry.id]) }, headers: request_login
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to eq('application/json')
    end

    it "return 404 when industry ID is invalid" do
      patch company_path(company.id), params: { company: company.as_json.merge(industry_ids: [0]) }, headers: header
      expect_not_found
    end

    it "return 404 when industry ID is deleted" do
      industry.discard
      patch company_path(company.id), params: { company: company.as_json.merge(industry_ids: [industry.id]) }, headers: header

      expect_not_found
    end
  end

  describe "PATCH #update", authorized: false do
    it "returns an unauthorized response" do
      patch company_path(0), params: { company: {}, id: 0 }
      expect_unauthorized
    end
  end

  describe "DELETE #destroy", authorized: true do
    let(:company) { create(:company) }
    let(:header) { request_login }
    it "returns a success response" do
      delete company_path(company.id), params: {}, headers: header
      expect(response.status).to eq(204)
    end

    it "returns a not found response if company is not found" do
      delete company_path(0), params: {}, headers: header
      expect(response.status).to eq(404)
    end

    it "returns a not found response if the company is already deleted" do
      company.discard
      delete company_path(company.id), params: {}, headers: header
      expect(response.status).to eq(404)
    end
  end

  describe "DELETE #destroy", authorized: false do
    it "returns an unauthorized response" do
      delete company_path(0), params: {}, headers: nil
      expect_unauthorized
    end
  end
end
