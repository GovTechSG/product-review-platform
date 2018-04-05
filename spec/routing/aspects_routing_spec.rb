require "rails_helper"

RSpec.describe AspectsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/v1/aspects").to route_to("aspects#index")
    end

    it "routes to #show" do
      expect(get: "/api/v1/aspects/1").to route_to("aspects#show", id: "1")
    end

    it "routes to #create" do
      expect(post: "/api/v1/aspects").to route_to("aspects#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/api/v1/aspects/1").to route_to("aspects#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/api/v1/aspects/1").to route_to("aspects#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/api/v1/aspects/1").to route_to("aspects#destroy", id: "1")
    end
  end
end
