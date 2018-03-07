require "rails_helper"

RSpec.describe ApidocsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/json").to route_to("apidocs#index")
    end
  end
end
