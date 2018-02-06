require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe TokensController, type: :controller do
  describe "POST #token" do
    it "returns a success response" do
      post :create, params: {
        "password": "test12",
        "name": "BGP"
      }
      expect(response).to be_success
      expect(response.body).to look_like_json
      expect(body_as_json.keys).to contain_exactly('access_token', 'token_type', 'created_at')
    end
  end
end