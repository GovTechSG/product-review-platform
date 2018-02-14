require "rails_helper"

RSpec.describe StatisticsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/v1/statistics").to route_to("statistics#index")
    end
  end
end
