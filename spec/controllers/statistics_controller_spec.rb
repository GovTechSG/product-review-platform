# TODO: Currently the tests are written to test if ApiController works.
# More specific tests will be added in later user stories
require 'rails_helper'

RSpec.describe StatisticsController, type: :controller do
  let(:token) { double acceptable?: true }
  before do
    allow(controller).to receive(:doorkeeper_token) { token }
  end
  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_success
    end
  end
end
