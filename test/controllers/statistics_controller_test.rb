require 'test_helper'

class StatisticsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auth_headers = users(:one).create_new_auth_token
  end

  test "should not get index if not signed in" do
    get statistics_url, as: :json

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should get index" do
    get statistics_url, headers: @auth_headers, as: :json

    assert_response :success
    body = JSON.parse(response.body)
    assert_equal Review.count, body["reviews"]
    assert_equal Company.count, body["companies"]
    assert_equal Product.count, body["products"]
    assert_equal Service.count, body["services"]
  end
end
