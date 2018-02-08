# TODO: Currently the tests are written to test if ApplicationController works.
# More specific tests will be added in later user stories
require 'rails_helper'

RSpec.describe ApidocsController, type: :controller do
  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_success
    end
  end
end
