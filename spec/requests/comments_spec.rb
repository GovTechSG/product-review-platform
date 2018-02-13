require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Comments", type: :request do
  describe "GET /comments/:id" do
    it "should route to comments#show" do
      header = request_login
      comment = create(:product_review_comment)
      get comment_path(comment.id), params: {}, headers: header
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /comments/:id" do
    it "should return unauthorized response" do
      @expected = unauthorized_response
      comment = create(:product_review_comment)
      get comment_path(comment.id), params: {}, headers: nil

      expect(response).to have_http_status(401)
      expect(response.body).to look_like_json
      expect(parsed_response).to match(@expected)
    end
  end
end
