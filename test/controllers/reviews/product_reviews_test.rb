require 'test_helper'

class ProductReviewsTest < ActionDispatch::IntegrationTest
  setup do
    @review = reviews(:pivotal_tracker_review_one)
    @product = Product.find(@review.reviewable_id)
    @company = @product.company
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
      review["company"] = reviews[idx].company
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
      company_id: @company.id,
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
      company_id: @company.id,
    }

    # Test updating of associated company scores
    old_total_score = @company.aggregate_score * @company.reviews_count

    assert_difference('Review.count') do
      post product_reviews_url(@product.id), params: { review: review }, headers: @auth_headers, as: :json
    end

    # Reload company from database
    @company.reload
    expected_aggregate_score = (old_total_score + review[:score])/@company.reviews_count
    assert_equal_float expected_aggregate_score, @company.aggregate_score

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
    expected["company"] = @review.company
    expected["likes_count"] = @review.likes_count
    expected["comments_count"] = @review.comments_count

    assert_equal expected.to_json, response.body
  end

  test "should not update product review if not signed in" do
    current = {
      score: @review.score,
      content: @review.content
    }
    updated = {
      score: 3,
      content: "Okay tracker"
    }
    patch review_url(@review), params: { review: updated }, as: :json

    # Assert unchanged
    @review.reload
    assert_equal current[:score], @review.score
    assert_equal current[:content], @review.content

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should update product review" do
    old_review_score = @review[:score]
    # Test updating of associated company scores
    old_total_score = @company.aggregate_score * @company.reviews_count

    updated = {
      score: 3,
      content: "Okay tracker"
    }
    patch review_url(@review), params: { review: updated }, headers: @auth_headers, as: :json

    # Reload company from database
    @company.reload
    expected_aggregate_score = (old_total_score - old_review_score + updated[:score])/@company.reviews_count
    assert_equal_float expected_aggregate_score, @company.aggregate_score

    # Check that review was updated
    @review.reload
    assert_equal updated[:score], @review.score
    assert_equal updated[:content], @review.content

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
    old_review_score = @review[:score]
    # Test updating of associated company scores
    old_total_score = @company.aggregate_score * @company.reviews_count

    assert_difference('Review.count', -1) do
      delete review_url(@review), headers: @auth_headers, as: :json
    end

    # Reload company from database
    @company.reload
    expected_aggregate_score = (old_total_score - old_review_score)/@company.reviews_count
    assert_equal_float expected_aggregate_score, @company.aggregate_score

    assert_response 204
  end
end