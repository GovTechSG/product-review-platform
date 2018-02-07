RSpec.describe CompaniesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(post: "/oauth/token").to route_to("tokens#create")
    end
  end
end