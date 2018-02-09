require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Tokens", type: :request do
  describe "GET /oauth/token" do
    it "should return access token" do
      authorized_app = create(:app)
      @app_params = {
        "password": authorized_app.password,
        "name": authorized_app.name
      }.as_json
      post oauth_sign_in_path, params: @app_params
      expect(response).to have_http_status(200)
      expect(response.body).to look_like_json
      expect(body_as_json.keys).to contain_exactly('access_token', 'token_type', 'created_at')
    end
  end

  describe "GET /oauth/token unauthorised" do
    it "should return unauthorized response" do
      @expected = wrong_credentials_response
      authorized_app = build(:app)
      @app_params = {
        "password": authorized_app.password,
        "name": authorized_app.name
      }.as_json
      post oauth_sign_in_path, params: @app_params

      expect(response).to have_http_status(401)
      expect(response.body).to look_like_json
      expect(body_as_json).to match(@expected)
    end
  end

  describe "GET /oauth/revoke" do
    it "should return access token" do
      headers = request_login
      post oauth_revoke_path, params: { token: headers['Authorization'].split(' ')[1] }
      expect(response).to have_http_status(200)
      expect(response.body).to look_like_json
      expect(body_as_json).to match({})
    end
  end

  describe "GET /oauth/revoke not found" do
    it "should return not found response" do
      @expected = incorrect_token_response
      request_login
      post oauth_revoke_path, params: {}

      expect(response).to have_http_status(404)
      expect(response.body).to look_like_json
      expect(body_as_json).to match(@expected)
    end
  end

  describe "GET /oauth/refresh" do
    it "should return new access token" do
      authorized_app = create(:app)
      @app_params = {
        "password": authorized_app.password,
        "name": authorized_app.name
      }.as_json
      post oauth_sign_in_path, params: @app_params
      env ||= {}
      env['Authorization'] = "Bearer " + JSON.parse(response.body)["access_token"]
      post oauth_refresh_path, params: @app_params, headers: env
      expect(response).to have_http_status(200)
      expect(response.body).to look_like_json
      expect(body_as_json.keys).to contain_exactly('access_token', 'token_type', 'created_at')
    end
  end

  describe "GET /oauth/refresh unauthorized" do
    it "should return unauthorized response" do
      authorized_app = create(:app)
      @app_params = {
        "password": authorized_app.password,
        "name": authorized_app.name
      }.as_json
      post oauth_sign_in_path, params: @app_params
      post oauth_refresh_path, params: @app_params
      expect(response).to have_http_status(401)
      expect(response.body).to look_like_json
      expect(body_as_json).to match(refresh_wrong_parameter_response)
    end
  end
end