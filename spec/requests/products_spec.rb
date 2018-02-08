# TODO: Currently the tests are written to test if ApiController works.
# More specific tests will be added in later user stories
require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Products", type: :request do
  describe "GET /products/:id" do
    it "should route to products#show" do
      header = request_login
      product = create(:product)
      get product_path(product.id), params: {}, headers: header
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /products/1" do
    it "should return unauthorized response" do
      @expected = unauthorized_response

      product = create(:product)
      get product_path(product.id), params: {}, headers: nil

      expect(response).to have_http_status(401)
      expect(response.body).to look_like_json
      expect(body_as_json).to match(@expected)
    end
  end
end