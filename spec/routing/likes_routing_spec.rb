require "rails_helper"

RSpec.describe LikesController, type: :routing do
  describe "routing" do
    it "routes to #show" do
      expect(get: "/likes/1").to route_to("likes#show", id: "1")
    end
  end
end
