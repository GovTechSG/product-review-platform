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
  end

  describe "POST #create", authorized: false do
    it "returns an unauthorized response" do
      post :create, params: { company: {} }
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
      expect(company.attributes.except('id', 'created_at', 'updated_at')).to match(updated_company.attributes.except('id', 'created_at', 'updated_at'))
    end

    it "returns Unprocessable Entity if company is not valid" do
      original_company = company
      patch :update, params: { company: Company.new(aggregate_score: 6).as_json, id: company.id }
      company.reload
      expect(company).to match(original_company)
      expect(response.status).to eq(422)
      expect(parsed_response.keys).to contain_exactly('name', 'UEN', 'description', 'aggregate_score')
    end
  end

  describe "PATCH #update", authorized: false do
    it "returns an unauthorized response" do
      patch :update, params: { company: {}, id: 0 }
      expect_unauthorized
    end
  end
end
