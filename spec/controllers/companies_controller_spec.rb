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

    it "returns data of an single student" do
      get :show, params: { id: company.id }, format: :json
      expect_show_response
    end

    it "returns not found if the student does not exist" do
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
end
