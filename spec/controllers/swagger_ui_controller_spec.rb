require 'rails_helper'

RSpec.describe SwaggerUiController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #apidoc" do
    it "returns a success response" do
      get :apidoc
      expect(response).to be_success
    end
  end
end
