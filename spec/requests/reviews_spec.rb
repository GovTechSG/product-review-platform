require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Reviews", type: :request do
  describe "GET /reviews/1" do
    it "reviews#show" do
      header = request_login

      review = create(:product_review)
      get review_path(review.id), params: {}, headers: header
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /reviews/1" do
    it "should return unauthorized response" do
      @expected = unauthorized_response

      review = create(:product_review)
      get review_path(review.id), params: {}, headers: nil

      expect(response).to have_http_status(401)
      expect(response.body).to look_like_json
      expect(body_as_json).to match(@expected)
    end
  end
end
