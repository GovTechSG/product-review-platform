require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe TokensController, type: :controller do
  describe "POST #token" do
    it "returns a success response" do
      authorized_app = create(:app)
      @app_params = {
        "password": authorized_app.password,
        "name": authorized_app.name
      }
      post :create, params: @app_params
      expect(response).to be_success
      expect(response.body).to look_like_json
      expect(body_as_json.keys).to contain_exactly('access_token', 'token_type', 'created_at')
    end
  end

  describe "POST #token unauthorized" do
    it "returns a unauthorized response" do
      @expected = wrong_credentials_response
      unauthorized_app = build(:app)
      @app_params = {
        "password": unauthorized_app.password,
        "name": unauthorized_app.name
      }
      post :create, params: @app_params
      expect(response.body).to look_like_json
      expect(response).to be_unauthorized
      expect(body_as_json).to match(@expected)
    end
  end

  describe "POST #revoke" do
    it "returns a success response" do
      token = controller_login
      post :revoke, params: { token: token }
      expect(response).to be_success
      expect(response.body).to look_like_json
      expect(body_as_json).to match({})
    end
  end

  describe "POST #token incorrect" do
    it "returns a not found response" do
      @expected = incorrect_token_response
      token = { token: "" }
      post :revoke, params: token
      expect(response.body).to look_like_json
      expect(response.status).to eq(404)
      expect(body_as_json).to match(@expected)
    end
  end

  describe "POST #token already revoked" do
    it "returns a not found response" do
      @expected = revoked_token_response
      token = controller_login
      post :revoke, params: { token: token }
      post :revoke, params: { token: token }
      expect(response.body).to look_like_json
      expect(response.status).to eq(404)
      expect(body_as_json).to match(@expected)
    end
  end
end