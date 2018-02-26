require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Likes", type: :request do
  describe "GET /likes/:id" do
    it "should route to likes#show" do
      header = request_login
      like = create(:product_review_like)
      get like_path(like.id), params: {}, headers: header
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /likes/:id" do
    it "should return unauthorized response" do
      expected = unauthorized_response
      like = create(:product_review_like)
      get like_path(like.id), params: {}, headers: nil

      expect(response).to have_http_status(401)
      expect(response.body).to look_like_json
      expect(parsed_response).to match(expected)
    end
  end
end
