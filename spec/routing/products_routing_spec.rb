require "rails_helper"

RSpec.describe ProductsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "api/v1/companies/1/products").to route_to("products#index", company_id: "1")
    end

    it "routes to #show" do
      expect(get: "api/v1/products/1").to route_to("products#show", id: "1")
    end

    it "routes to #create" do
      expect(post: "api/v1/companies/1/products").to route_to("products#create", company_id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "api/v1/products/1").to route_to("products#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "api/v1/products/1").to route_to("products#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "api/v1/products/1").to route_to("products#destroy", id: "1")
    end
  end
end
