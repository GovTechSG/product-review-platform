require 'rails_helper'

RSpec.describe App, type: :model do
  describe "authenticate with valid params" do
    it "returns app" do
      app = create(:app)
      response = app.class.authenticate(app.name, app.password)

      expect(response).to match(app)
    end
  end

  describe "authenticate with invalid params" do
    it "returns app" do
      app = build(:app)
      response = app.class.authenticate(app.name, app.password)

      expect(response).to match(nil)
    end
  end
end
