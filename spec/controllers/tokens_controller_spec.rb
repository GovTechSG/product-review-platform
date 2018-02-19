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
      expect(parsed_response.keys).to contain_exactly('access_token', 'token_type', 'created_at')
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
      expect(parsed_response).to match(@expected)
    end
  end

  describe "POST #revoke" do
    it "returns a success response" do
      token = controller_login
      post :revoke, params: { token: token }
      expect(response).to be_success
      expect(response.body).to look_like_json
      expect(parsed_response).to match({})
    end
  end

  describe "POST #revoke incorrect" do
    it "returns a not found response" do
      @expected = incorrect_token_response
      token = { token: "" }
      post :revoke, params: token
      expect(response.body).to look_like_json
      expect(response.status).to eq(404)
      expect(parsed_response).to match(@expected)
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
      expect(parsed_response).to match(@expected)
    end
  end

  describe "POST #refresh" do
    it "returns a success response" do
      authorized_app = create(:app)
      @app_params = {
        "password": authorized_app.password,
        "name": authorized_app.name
      }
      post :create, params: @app_params
      @app_params[:token] = parsed_response['access_token']
      post :refresh, params: @app_params
      expect(response).to be_success
      expect(response.body).to look_like_json
      expect(parsed_response.keys).to contain_exactly('access_token', 'token_type', 'created_at')
    end
  end

  describe "POST #token refresh wrong parameter" do
    it "returns a unauthorized response" do
      authorized_app = create(:app)
      @app_params = {
        "password": authorized_app.password,
        "name": authorized_app.name
      }
      post :create, params: @app_params
      @request.headers['Authorization'] = "Bearer " + parsed_response['access_token']
      post :refresh, params: {}
      expect(response).to be_unauthorized
      expect(response.body).to look_like_json
      expect(parsed_response).to match(refresh_wrong_parameter_response)
    end
  end

  describe "POST #token refresh no header" do
    it "returns a unauthorized response" do
      authorized_app = create(:app)
      @app_params = {
        "password": authorized_app.password,
        "name": authorized_app.name
      }
      post :create, params: @app_params
      post :refresh, params: @app_params
      expect(response).to be_unauthorized
      expect(response.body).to look_like_json
      expect(parsed_response).to match(refresh_no_header_response)
    end
  end
end