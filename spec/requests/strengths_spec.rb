require 'rails_helper'

RSpec.describe "Strengths", type: :request do
  describe "GET /strengths" do
    it "works! (now write some real specs)" do
      get strengths_path
      expect(response).to have_http_status(200)
    end
  end
end
