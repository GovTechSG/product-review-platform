# TODO: Currently the tests are written to test if ApiController works.
# More specific tests will be added in later user stories
require 'rails_helper'
RSpec.describe LikesController, type: :controller do
  let(:token) { double acceptable?: true }
  before do
    allow(controller).to receive(:doorkeeper_token) {token}
  end
  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: 1 }
      expect(response).to be_success
    end
  end
end
