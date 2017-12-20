require 'test_helper'

class StatisticsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get statistics_url, as: :json

    assert_response :success
    body = JSON.parse(response.body)
    assert_equal Review.count, body["reviews"]
    assert_equal Company.count, body["companies"]
    assert_equal Product.count, body["products"]
    assert_equal Service.count, body["services"]
  end
end
