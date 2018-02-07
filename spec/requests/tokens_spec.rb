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

  describe "GET /oauth/token" do
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
end