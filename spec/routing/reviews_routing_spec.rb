require "rails_helper"

RSpec.describe ReviewsController, type: :routing do
  describe "routing" do
    it "routes to #show" do
      expect(:get => "/reviews/1").to route_to("reviews#show", :id => "1")
    end
  end
end
