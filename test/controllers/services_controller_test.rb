require 'test_helper'

class ServicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @service = services(:service_foo)
    @company = @service.company
    @auth_headers = users(:one).create_new_auth_token
  end

  test "should not get index if not signed in" do
    get company_services_url(@company.id), as: :json

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should get index" do
    get company_services_url(@company.id), headers: @auth_headers, as: :json

    assert_response :success

    services = @company.services
    expected = services.as_json
    # Call associated methods for each service
    expected.each_with_index do |service, idx|
      service["reviews_count"] = services[idx].reviews_count
      service["aggregate_score"] = services[idx].aggregate_score
    end
    assert_equal expected.to_json, response.body
  end

  test "should not create service if not signed in" do
    service = {
      name: "New Service",
      description: "New description",
      company_id: @company.id
    }
    assert_no_difference('Service.count') do
      post company_services_url(@company.id), params: { service: service }, as: :json
    end

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should create service" do
    service = {
      name: "New Service",
      description: "New description",
      company_id: @company.id
    }
    assert_difference('Service.count') do
      post company_services_url(@company.id), params: { service: service }, headers: @auth_headers, as: :json
    end

    assert_response 201
  end

  test "should not show service if not signed in" do
    get service_url(@service), as: :json

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should show service" do
    get service_url(@service), headers: @auth_headers, as: :json

    assert_response :success

    # Call associated methods on service
    expected = @service.as_json
    expected["reviews_count"] = @service.reviews_count
    expected["aggregate_score"] = @service.aggregate_score
    expected["company_name"] = @service.company_name

    assert_equal expected.to_json, response.body
  end

  test "should not update service if not signed in" do
    updated = {
      name: "New Service",
      description: "New description"
    }
    patch service_url(@service), params: { service: updated }, as: :json

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should update service" do
    updated = {
      name: "New Service",
      description: "New description"
    }
    patch service_url(@service), params: { service: updated }, headers: @auth_headers, as: :json
    assert_response 200
  end

  test "should not destroy service if not signed in" do
    assert_no_difference('Service.count') do
      delete service_url(@service), as: :json
    end

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should destroy service" do
    assert_difference('Service.count', -1) do
      delete service_url(@service), headers: @auth_headers, as: :json
    end

    assert_response 204
  end
end
