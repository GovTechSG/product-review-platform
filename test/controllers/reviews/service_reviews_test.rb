require 'test_helper'

class ServiceReviewsTest < ActionDispatch::IntegrationTest
  setup do
    @review = reviews(:service_foo_review_one)
    @service = Service.find(@review.reviewable_id)
    @agency = agencies(:one)
  end

  test "should get index" do
    get service_reviews_url(@service.id), as: :json

    assert_response :success
    assert_equal @service.reviews.to_json, response.body
  end

  test "should create review" do
    review = {
      score: 5,
      content: "Amazing service!",
      service_id: @service.id,
      agency_id: @agency.id,
    }
    assert_difference('Review.count') do
      post service_reviews_url(@service.id), params: { review: review }, as: :json
    end

    assert_response 201
  end

  test "should show review" do
    get review_url(@review), as: :json

    assert_response :success
    assert_equal @review.to_json, response.body
  end

  test "should update review" do
    updated = {
      score: 3,
      content: "Okay service"
    }
    patch review_url(@review), params: { review: updated }, as: :json
    assert_response 200
  end

  test "should destroy review" do
    assert_difference('Review.count', -1) do
      delete review_url(@review), as: :json
    end

    assert_response 204
  end
end
