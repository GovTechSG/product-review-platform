require 'test_helper'

class ProductReviewsTest < ActionDispatch::IntegrationTest
  setup do
    @review = reviews(:pivotal_tracker_review_one)
    @product = Product.find(@review.reviewable_id)
    @agency = agencies(:two)
    @auth_headers = users(:one).create_new_auth_token
  end

  test "should not get index if not signed in" do
    get product_reviews_url(@product.id), as: :json

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should get index" do
    get product_reviews_url(@product.id), headers: @auth_headers, as: :json

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

  test "should not create product review if not signed in" do
    review = {
      score: 5,
      content: "Amazing tracker!",
      product_id: @product.id,
      agency_id: @agency.id,
    }
    assert_no_difference('Review.count') do
      post product_reviews_url(@product.id), params: { review: review }, as: :json
    end

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should create product review" do
    review = {
      score: 5,
      content: "Amazing tracker!",
      product_id: @product.id,
      agency_id: @agency.id,
    }
    assert_difference('Review.count') do
      post product_reviews_url(@product.id), params: { review: review }, headers: @auth_headers, as: :json
    end

    assert_response 201
  end

  test "should not show product review if not signed in" do
    get review_url(@review), as: :json

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should show product review" do
    get review_url(@review), headers: @auth_headers, as: :json

    assert_response :success

    expected = @review.as_json
    # Call associated methods on review
    expected["agency"] = @review.agency
    expected["likes_count"] = @review.likes_count
    expected["comments_count"] = @review.comments_count

    assert_equal expected.to_json, response.body
  end

  test "should not update product review if not signed in" do
    updated = {
      score: 3,
      content: "Okay tracker"
    }
    patch review_url(@review), params: { review: updated }, as: :json

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should update product review" do
    updated = {
      score: 3,
      content: "Okay tracker"
    }
    patch review_url(@review), params: { review: updated }, headers: @auth_headers, as: :json

    assert_response 200
  end

  test "should not destroy product review if not signed in" do
    assert_no_difference('Review.count') do
      delete review_url(@review), as: :json
    end

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should destroy product review" do
    assert_difference('Review.count', -1) do
      delete review_url(@review), headers: @auth_headers, as: :json
    end

    assert_response 204
  end
end