RSpec.describe CompaniesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(post: "/api/v1/oauth/token").to route_to("tokens#create")
    end

    it "routes to #revoke" do
      expect(post: "/api/v1/oauth/revoke").to route_to("tokens#revoke")
    end
  end
end