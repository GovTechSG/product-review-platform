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
      name: "Agency Four",
      email: "agency_four@foo.com",
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
      name: "Agency Four",
      email: "agency_four@foo.com",
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
    current = {
      name: @agency.name,
      email: @agency.email,
      number: @agency.number
    }
    updated = {
      name: "Agency One New",
      email: "agency_one_new@foo.com",
      number: "113344564"
    }
    patch agency_url(@agency), params: { agency: updated }, as: :json

    # Assert unchanged
    @agency.reload
    assert_equal current[:name], @agency[:name]
    assert_equal current[:email], @agency[:email]
    assert_equal current[:number], @agency[:number]

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should update agency" do
    updated = {
      name: "Agency One New",
      email: "agency_one_new@foo.com",
      number: "113344564"
    }
    patch agency_url(@agency), params: { agency: updated }, headers: @auth_headers, as: :json

    @agency.reload
    assert_equal updated[:name], @agency.name
    assert_equal updated[:email], @agency.email
    assert_equal updated[:number], @agency.number

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
