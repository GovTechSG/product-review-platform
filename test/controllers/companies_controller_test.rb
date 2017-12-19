require 'test_helper'

class CompaniesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company = companies(:foo)
    @auth_headers = users(:one).create_new_auth_token
  end

  test "should not get index if not signed in" do
    get companies_url, as: :json

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should get index" do
    get companies_url, headers: @auth_headers, as: :json

    assert_response :success
    assert_equal Company.all.to_json, response.body
  end

  test "should not create company if not signed in" do
    company = {
      UEN: "32334557",
      aggregate_score: 3.5,
      name: "Company Two"
    }
    assert_no_difference('Company.count') do
      post companies_url, params: { company: company }, as: :json
    end

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should create company" do
    company = {
      UEN: "32334557",
      aggregate_score: 3.5,
      name: "Company Two"
    }
    assert_difference('Company.count') do
      post companies_url, params: { company: company }, headers: @auth_headers, as: :json
    end

    assert_response 201
  end

  test "should not show company if not signed in" do
    get company_url(@company), as: :json

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should show company" do
    get company_url(@company), headers: @auth_headers, as: :json

    assert_response :success
    assert_equal @company.to_json, response.body
  end

  test "should not update company if not signed in" do
    updated = {
      name: "New Company",
      UEN: "23456789",
      aggregate_score: 4.0
    }
    patch company_url(@company), params: { company: updated }, as: :json

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should update company" do
    updated = {
      name: "New Company",
      UEN: "23456789",
      aggregate_score: 4.0
    }
    patch company_url(@company), params: { company: updated }, headers: @auth_headers, as: :json
    assert_response 200
  end

  test "should not destroy company if not signed in" do
    assert_no_difference('Company.count') do
      delete company_url(@company), as: :json
    end

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should destroy company" do
    assert_difference('Company.count', -1) do
      delete company_url(@company), headers: @auth_headers, as: :json
    end

    assert_response 204
  end
end
