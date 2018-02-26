require "rails_helper"

RSpec.describe ServicesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "api/v1/companies/1/services").to route_to("services#index", company_id: "1")
    end

    it "routes to #show" do
      expect(get: "api/v1/services/1").to route_to("services#show", id: "1")
    end

    it "routes to #create" do
      expect(post: "api/v1/companies/1/services").to route_to("services#create", company_id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "api/v1/services/1").to route_to("services#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "api/v1/services/1").to route_to("services#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "api/v1/services/1").to route_to("services#destroy", id: "1")
    end
  end
end
