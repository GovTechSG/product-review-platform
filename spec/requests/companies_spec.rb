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

  describe "GET companies/:company_id/clients" do
    let(:header) { request_login }
    let(:company) { create(:company) }
    it "returns a success response" do
      get companies_clients_path(company.id), headers: header
      expect(response).to be_success
    end

    it "returns empty array if there are no clients" do
      get companies_clients_path(company.id), headers: header
      expect(parsed_response).to eq([])
    end

    it "returns product clients if there are only product clients" do
      product = company.products.create! build(:product).attributes
      product.reviews.create! build(:product_review).attributes
      get companies_clients_path(company.id), headers: header
      expect(parsed_response.length).to eq(1)
    end

    it "returns service clients if there are only service clients" do
      service = company.services.create! build(:service).attributes
      service.reviews.create! build(:service_review).attributes
      get companies_clients_path(company.id), headers: header
      expect(parsed_response.length).to eq(1)
    end

    it "does not return deleted products" do
      product = company.products.create! build(:product).attributes
      product.reviews.create! build(:product_review).attributes
      product.discard
      get companies_clients_path(company.id), headers: header
      expect(parsed_response.length).to eq(0)
    end

    it "does not return deleted services" do
      service = company.services.create! build(:service).attributes
      service.reviews.create! build(:service_review).attributes
      service.discard
      get companies_clients_path(company.id), headers: header
      expect(parsed_response.length).to eq(0)
    end

    it "does not return deleted products review" do
      product = company.products.create! build(:product).attributes
      review = product.reviews.create! build(:product_review).attributes
      review.discard
      get companies_clients_path(company.id), headers: header
      expect(parsed_response.length).to eq(0)
    end

    it "does not return deleted services review" do
      service = company.services.create! build(:service).attributes
      review = service.reviews.create! build(:service_review).attributes
      review.discard
      get companies_clients_path(company.id), headers: header
      expect(parsed_response.length).to eq(0)
    end

    it "returns product and service clients" do
      product = company.products.create! build(:product).attributes
      product.reviews.create! build(:product_review).attributes
      service = company.services.create! build(:service).attributes
      service.reviews.create! build(:service_review).attributes
      get companies_clients_path(company.id), headers: header
      expect(parsed_response.length).to eq(2)
    end

    it "returns not found if company is not found" do
      get companies_clients_path(0), headers: header
      expect(response.status).to eq(404)
    end

    it "returns not found if company is deleted" do
      company.discard
      get companies_clients_path(company.id), headers: header
      expect(response.status).to eq(404)
    end
  end

  describe "GET companies/:company_id/clients unauthorized" do
    let(:company) { create(:company) }
    it "returns an unauthorized response" do
      get companies_clients_path(company.id)
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

    it "renders a 422 error for duplicate uen" do
      dupcompany = build(:company)
      dupcompany.uen = company.uen
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
      patch company_path(company.id), params: { company: attributes_for(:company, uen: another_company.uen).as_json.merge(industry_ids: [industry.id]), id: company.id }, headers: header
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

    it "renders a 422 error for duplicate uen" do
      dupcompany = build(:company)
      dupcompany.save
      company.uen = dupcompany.uen
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

  describe "PATCH #update" do
    it "returns an unauthorized response" do
      patch company_path(0), params: { company: {}, id: 0 }
      expect_unauthorized
    end
  end

  describe "DELETE #destroy" do
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

  describe "DELETE #destroy" do
    it "returns an unauthorized response" do
      delete company_path(0), params: {}, headers: nil
      expect_unauthorized
    end
  end
end
