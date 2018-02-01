require "rails_helper"

RSpec.describe AgenciesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/agencies").to route_to("agencies#index")
    end


    it "routes to #show" do
      expect(:get => "/agencies/1").to route_to("agencies#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/agencies").to route_to("agencies#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/agencies/1").to route_to("agencies#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/agencies/1").to route_to("agencies#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/agencies/1").to route_to("agencies#destroy", :id => "1")
    end

  end
end
