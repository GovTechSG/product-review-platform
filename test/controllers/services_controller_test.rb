require 'test_helper'

class ServicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @service = services(:service_foo)
    @company = @service.company
  end

  test "should get index" do
    get company_services_url(@company.id), as: :json

    assert_response :success
    assert_equal @company.services.to_json, response.body
  end

  test "should create service" do
    service = {
      name: "New Service",
      description: "New description",
      company_id: @company.id
    }
    assert_difference('Service.count') do
      post company_services_url(@company.id), params: { service: service }, as: :json
    end

    assert_response 201
  end

  test "should show service" do
    get service_url(@service), as: :json

    assert_response :success
    assert_equal @service.to_json, response.body
  end

  test "should update service" do
    updated = {
      name: "New Service",
      description: "New description",
      company_id: @company.id
    }
    patch service_url(@service), params: { service: updated }, as: :json
    assert_response 200
  end

  test "should destroy service" do
    assert_difference('Service.count', -1) do
      delete service_url(@service), as: :json
    end

    assert_response 204
  end
end
