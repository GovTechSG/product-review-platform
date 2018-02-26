require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def test_record_not_found
      fail ActiveRecord::RecordNotFound
    end

    def test_parameter_missing
      fail ActionController::ParameterMissing, :test
    end

    def test_record_not_unique
      fail ActiveRecord::RecordNotUnique
    end
  end

  before :each do
    routes.draw do
      get "test_record_not_found" => "anonymous#test_record_not_found"
      get "test_parameter_missing" => "anonymous#test_parameter_missing"
      get "test_record_not_unique" => "anonymous#test_record_not_unique"
    end
  end

  it "rescues record not found with 404" do
    get :test_record_not_found
    expect(response).to have_http_status(404)
  end

  it "rescues parameter missing with 400" do
    get :test_parameter_missing
    expect(response).to have_http_status(400)
  end

  it "rescues record not unique with 422" do
    get :test_record_not_unique
    expect(response).to have_http_status(422)
  end
end
