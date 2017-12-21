require 'test_helper'

class ProductReviewsTest < ActionDispatch::IntegrationTest
  setup do
    @review = reviews(:pivotal_tracker_review_one)
    @product = Product.find(@review.reviewable_id)
    @agency = agencies(:two)
  end

  test "should get index" do
    get product_reviews_url(@product.id), as: :json

    assert_response :success

    reviews = @product.reviews
    expected = reviews.as_json
    # Call associated methods for each product
    expected.each_with_index do |review, idx|
      review["agency"] = reviews[idx].agency
      review["likes_count"] = reviews[idx].likes_count
      review["comments_count"] = reviews[idx].comments_count
    end
    assert_equal expected.to_json, response.body
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

    expected = @review.as_json
    # Call associated methods on review
    expected["agency"] = @review.agency
    expected["likes_count"] = @review.likes_count
    expected["comments_count"] = @review.comments_count

    assert_equal expected.to_json, response.body
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
