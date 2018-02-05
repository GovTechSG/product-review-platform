require "rails_helper"

RSpec.describe CommentsController, type: :routing do
  describe "routing" do
    it "routes to #show" do
      expect(:get => "/comments/1").to route_to("comments#show", :id => "1")
    end
  end
end
