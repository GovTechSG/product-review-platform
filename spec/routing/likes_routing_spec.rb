require "rails_helper"

RSpec.describe LikesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/v1/reviews/1/likes").to route_to("likes#index", review_id: "1")
    end
    it "routes to #create" do
      expect(post: "/api/v1/reviews/1/likes").to route_to("likes#create", review_id: "1")
    end
    it "routes to #destroy" do
      expect(delete: "/api/v1/likes/1").to route_to("likes#destroy", id: "1")
    end
    it "routes to #show" do
      expect(get: "/api/v1/likes/1").to route_to("likes#show", id: "1")
    end
  end
end
