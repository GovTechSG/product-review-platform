require 'test_helper'

class ProductReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @review = reviews(:pivotal_tracker_review_one)
    @product = Product.find(@review.reviewable_id)
    @agency = agencies(:two)
  end

  test "should get index" do
    get product_reviews_url(@product.id), as: :json

    assert_response :success
    assert_equal @product.reviews.to_json, response.body
  end

  test "should create review" do
    review = {
      score: 5,
      content: "Amazing tracker!",
      product_id: @product.id,
      agency_id: @agency.id,
    }
    assert_difference('Review.count') do
      post product_reviews_url(@product.id), params: { review: review }, as: :json
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
      content: "Okay tracker"
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
