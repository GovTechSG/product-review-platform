require "rails_helper"

RSpec.describe ReviewsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/v1/products/1/reviews").to route_to("reviews#index", product_id: "1")
      expect(get: "/api/v1/services/1/reviews").to route_to("reviews#index", service_id: "1")
    end

    it "routes to #create" do
      expect(post: "/api/v1/products/1/reviews").to route_to("reviews#create", product_id: "1")
      expect(post: "/api/v1/services/1/reviews").to route_to("reviews#create", service_id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "/api/v1/reviews/1").to route_to("reviews#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/api/v1/reviews/1").to route_to("reviews#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/api/v1/reviews/1").to route_to("reviews#destroy", id: "1")
    end

    it "routes to #show" do
      expect(get: "/api/v1/reviews/1").to route_to("reviews#show", id: "1")
    end
  end
end
