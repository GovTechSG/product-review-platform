require "rails_helper"

RSpec.describe ApplicationController, type: :routing do
  describe "root routing" do
    it "routes to swagger_ui#index" do
      expect(get: "/").to route_to("swagger_ui#index")
    end
  end
end
