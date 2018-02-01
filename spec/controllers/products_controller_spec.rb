# TODO: Currently the tests are written to test if ApiController works. 
# More specific tests will be added in later user stories
require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let(:valid_user){
    User.first
  }
  before { subject.stub(current_user: valid_user, authenticate_user!: true) }

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: {id: 1}
      expect(response).to be_success
    end
  end
end
