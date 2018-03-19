require "rails_helper"

RSpec.describe StrengthsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/v1/strengths").to route_to("strengths#index")
    end

    it "routes to #show" do
      expect(get: "/api/v1/strengths/1").to route_to("strengths#show", id: "1")
    end

    it "routes to #create" do
      expect(post: "/api/v1/strengths").to route_to("strengths#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/api/v1/strengths/1").to route_to("strengths#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/api/v1/strengths/1").to route_to("strengths#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/api/v1/strengths/1").to route_to("strengths#destroy", id: "1")
    end
  end
end
