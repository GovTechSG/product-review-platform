require "rails_helper"

RSpec.describe ServicesController, type: :routing do
  describe "routing" do
    it "routes to #show" do
      expect(get: "/api/v1/services/1").to route_to("services#show", id: "1")
    end
  end
end
