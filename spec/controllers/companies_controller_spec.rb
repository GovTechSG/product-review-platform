require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe CompaniesController, type: :controller do
  let(:token) { double acceptable?: true }
  before(:each, authorized: true) do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  describe "GET #index", authorized: true do
    it "returns a success response" do
      get :index
      expect(response).to be_success
    end

    it "returns all company" do
      create_list(:company, 5)
      get :index
      expect(parsed_response.length).to eq(5)
    end

    it "does not return deleted companies" do
      create_list(:company, 5)
      Company.first.discard
      get :index
      expect(parsed_response.length).to eq(4)
    end
  end

  describe "GET #index", authorized: false do
    it "returns an unauthorized response" do
      get :index, params: {}
      expect_unauthorized
    end
  end

  describe "GET #show", authorized: true do
    let(:company) { create(:company) }
    it "returns a success response" do
      get :show, params: { id: company.id }
      expect(response).to be_success
    end

    it "returns data of an single company" do
      get :show, params: { id: company.id }, format: :json
      expect_show_response
    end

    it "returns not found if the company does not exist" do
      get :show, params: { id: 0 }, format: :json
      expect_not_found
    end
    it "returns 404 if company has already been soft deleted" do
      company.discard
      get :show, params: { id: company.id }
      expect_not_found
    end
  end

  describe "GET #show", authorized: false do
    it "returns an unauthorized response" do
      get :show, params: { id: 0 }, format: :json
      expect_unauthorized
    end
  end

  describe "POST #create", authorized: true do
    let(:company) { build(:company) }
    it "returns a success response" do
      post :create, params: { company: company.as_json }
      expect(response.status).to eq(201)
    end

    it "returns data of the single created company" do
      post :create, params: { company: company.as_json }
      expect_show_response
    end

    it "returns Unprocessable Entity if company is not valid" do
      company.name = ""
      post :create, params: { company: company.as_json }
      expect(response.status).to eq(422)
    end

    it "renders a 422 error for duplicate UEN", authorized: true do
      @dupcompany = build(:company)
      @dupcompany.UEN = company.UEN
      @dupcompany.save
      post :create, params: { company: company.as_json }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to eq('application/json')
    end

    it "return 404 when industry ID is invalid" do
      post :create, params: { company: company.as_json.merge(industry_ids: [0]) }
      expect_not_found
    end
  end

  describe "POST #create", authorized: false do
    it "returns an unauthorized response" do
      post :create, params: { company: {} }
      expect_unauthorized
    end
  end

  describe "PATCH #update", authorized: true do
    let(:company) { create(:company) }
    it "returns a success response" do
      patch :update, params: { company: company.as_json, id: company.id }
      expect(response.status).to eq(200)
    end

    it "returns data of the single updated company" do
      updated_company = build(:company)
      patch :update, params: { company: updated_company.as_json, id: company.id }
      company.reload
      expect(company.attributes.except('id', 'created_at', 'updated_at', 'aggregate_score')).to match(updated_company.attributes.except('id', 'created_at', 'updated_at', 'aggregate_score'))
    end

    it "returns Unprocessable Entity if company is not valid" do
      original_company = company
      another_company = create(:company)
      patch :update, params: { company: attributes_for(:company, UEN: another_company.UEN).as_json, id: company.id }
      company.reload
      expect(company).to match(original_company)
      expect(response.status).to eq(422)
    end

    it "returns not found if company id is not valid" do
      original_company = company
      patch :update, params: { company: build(:company).as_json, id: 0 }
      company.reload
      expect(company).to match(original_company)
      expect(response.status).to eq(404)
    end

    it "returns 400 if company is not provided" do
      original_company = company
      patch :update, params: { id: original_company.id }
      company.reload
      expect(company).to match(original_company)
      expect(response.status).to eq(400)
    end

    it "returns 404 if company has already been soft deleted" do
      original_company = company
      original_company.discard
      patch :update, params: { company: company.as_json, id: company.id }
      company.reload
      expect(company).to match(original_company)
      expect(response.status).to eq(404)
    end

    it "renders a 422 error for duplicate UEN", authorized: true do
      @dupcompany = create(:company)

      patch :update, params: { company: company.as_json, id: @dupcompany.id }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to eq('application/json')
    end

    it "return 404 when industry ID is invalid" do
      patch :update, params: { company: company.as_json.merge(industry_ids: [0]), id: company.id }
      expect_not_found
    end
  end

  describe "PATCH #update", authorized: false do
    it "returns an unauthorized response" do
      patch :update, params: { company: {}, id: 0 }
      expect_unauthorized
    end
  end

  describe "DELETE #destroy", authorized: true do
    it "returns a success response" do
      company = create(:company)
      delete :destroy, params: { id: company.id }
      expect(response.status).to eq(204)
    end

    it "sets company's discarded_at column" do
      company = create(:company)
      delete :destroy, params: { id: company.id }
      company.reload
      expect(company.discarded?).to be true
    end

    it "returns a not found response if company is not found" do
      delete :destroy, params: { id: 0 }
      expect(response.status).to eq(404)
    end

    it "returns a not found response if company is already deleted" do
      company = create(:company)
      company.discard
      delete :destroy, params: { id: company.id }
      expect(response.status).to eq(404)
    end
  end

  describe "DELETE #destroy", authorized: false do
    it "returns an unauthorized response" do
      delete :destroy, params: { id: 0 }, format: :json
      expect_unauthorized
    end
  end
end
