require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe ReviewsController, type: :controller do
  let(:token) { double acceptable?: true }
  before(:each, authorized: true) do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  describe "GET #show", authorized: true do
    it "returns a success response" do
      product_review = create(:product_review)
      get :show, params: { id: product_review.id }
      expect(response).to be_success
    end
  end

  describe "GET #show", authorized: false do
    it "returns an unauthorized response" do
      @expected = unauthorized_response

      product_review = create(:product_review)
      get :show, params: { id: product_review.id }

      expect(response.body).to look_like_json
      expect(response).to be_unauthorized
      expect(parsed_response).to match(@expected)
    end
  end
end
