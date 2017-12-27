require 'test_helper'

class AgenciesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @agency = agencies(:one)
    @auth_headers = users(:one).create_new_auth_token
  end

  test "should not get index if not signed in" do
    get agencies_url, as: :json

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should get index" do
    get agencies_url, headers: @auth_headers, as: :json

    assert_response :success
    assert_equal Agency.all.to_json, response.body
  end

  test "should not create agency if not signed in" do
    agency = {
      email: "agency_four@foo.com",
      name: "Agency Four",
      number: "11113333"
    }
    assert_no_difference('Agency.count') do
      post agencies_url, params: { agency: agency }, as: :json
    end

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should create agency" do
    agency = {
      email: "agency_four@foo.com",
      name: "Agency Four",
      number: "11113333"
    }
    assert_difference('Agency.count') do
      post agencies_url, params: { agency: agency }, headers: @auth_headers, as: :json
    end

    assert_response 201
  end

  test "should not show agency if not signed in" do
    get agency_url(@agency), as: :json

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should show agency" do
    get agency_url(@agency), headers: @auth_headers, as: :json

    assert_response :success
    assert_equal @agency.to_json, response.body
  end

  test "should not update agency if not signed in" do
    updated = {
      email: @agency.email,
      name: @agency.name,
      number: @agency.number
    }
    patch agency_url(@agency), params: { agency: updated }, as: :json

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should update agency" do
    updated = {
      email: @agency.email,
      name: @agency.name,
      number: @agency.number
    }
    patch agency_url(@agency), params: { agency: updated }, headers: @auth_headers, as: :json
    assert_response 200
  end

  test "should not destroy agency if not signed in" do
    assert_no_difference('Agency.count') do
      delete agency_url(@agency), as: :json
    end

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should destroy agency" do
    assert_difference('Agency.count', -1) do
      delete agency_url(@agency), headers: @auth_headers, as: :json
    end

    assert_response 204
  end
end
