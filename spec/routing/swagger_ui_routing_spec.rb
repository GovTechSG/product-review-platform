require "rails_helper"

RSpec.describe SwaggerUiController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/docs").to route_to("swagger_ui#apidoc")
    end

    it "routes to #apidoc" do
      expect(get: "/").to route_to("swagger_ui#index")
    end
  end
end
