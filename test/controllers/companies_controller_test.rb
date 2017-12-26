require 'test_helper'

class CompaniesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company = companies(:foo)
  end

  test "should get index" do
    get companies_url, as: :json

    assert_response :success

    companies = Company.all
    expected = companies.as_json
    # Call associated methods for each company
    expected.each_with_index do |company, idx|
      company["reviews_count"] = companies[idx].reviews_count
    end
    assert_equal expected.to_json, response.body
  end

  test "should create company" do
    company = {
      UEN: "32334557",
      aggregate_score: 3.5,
      name: "Company Two"
    }
    assert_difference('Company.count') do
      post companies_url, params: { company: company }, as: :json
    end

    assert_response 201
  end

  test "should show company" do
    get company_url(@company), as: :json

    assert_response :success

    expected = @company.as_json
    # Call associated methods on company
    expected["reviews_count"] = @company.reviews_count

    assert_equal expected.to_json, response.body
  end

  test "should update company" do
    updated = {
      name: "New Company",
      UEN: "23456789",
      aggregate_score: 4.0
    }
    patch company_url(@company), params: { company: updated }, as: :json
    assert_response 200
  end

  test "should destroy company" do
    assert_difference('Company.count', -1) do
      delete company_url(@company), as: :json
    end

    assert_response 204
  end
end
