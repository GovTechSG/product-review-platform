require 'test_helper'

class ServiceReviewsTest < ActionDispatch::IntegrationTest
  setup do
    @review = reviews(:service_foo_review_one)
    @service = Service.find(@review.reviewable_id)
    @company = @service.company
    @auth_headers = users(:one).create_new_auth_token
  end

  test "should not get index if not signed in" do
    get service_reviews_url(@service.id), as: :json

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should get index" do
    get service_reviews_url(@service.id), headers: @auth_headers, as: :json

    assert_response :success

    reviews = @service.reviews
    expected = reviews.as_json
    # Call associated methods for each review
    expected.each_with_index do |review, idx|
      review["company"] = reviews[idx].company
      review["likes_count"] = reviews[idx].likes_count
      review["comments_count"] = reviews[idx].comments_count
    end
    assert_equal expected.to_json, response.body
  end

  test "should not create service review if not signed in" do
    review = {
      score: 5,
      content: "Amazing service!",
      service_id: @service.id,
      company_id: @company.id,
    }
    assert_no_difference('Review.count') do
      post service_reviews_url(@service.id), params: review, as: :json
    end

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should create service review" do
    review = {
      score: 5,
      content: "Amazing service!",
      service_id: @service.id,
      company_id: @company.id,
    }

    # Test updating of associated company scores
    old_total_score = @company.aggregate_score * @company.reviews_count

    assert_difference('Review.count') do
      post service_reviews_url(@service.id), params: review, headers: @auth_headers, as: :json
    end

    # Reload company from database
    @company.reload
    expected_aggregate_score = (old_total_score + review[:score])/@company.reviews_count
    assert_equal_float expected_aggregate_score, @company.aggregate_score

    assert_response 201
  end

  test "should not show service review if not signed in" do
    get review_url(@review), as: :json

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should show service review" do
    get review_url(@review), headers: @auth_headers, as: :json

    assert_response :success

    expected = @review.as_json
    # Call associated methods on review
    expected["company"] = @review.company
    expected["likes_count"] = @review.likes_count
    expected["comments_count"] = @review.comments_count

    assert_equal expected.to_json, response.body
  end

  test "should not update service review if not signed in" do
    updated = {
      score: 3,
      content: "Okay service"
    }
    patch review_url(@review), params: updated, as: :json

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should update service review" do
    old_review_score = @review[:score]
    # Test updating of associated company scores
    old_total_score = @company.aggregate_score * @company.reviews_count

    updated = {
      score: 3,
      content: "Okay service"
    }
    patch review_url(@review), params: updated, headers: @auth_headers, as: :json

    # Reload company from database
    @company.reload
    expected_aggregate_score = (old_total_score - old_review_score + updated[:score])/@company.reviews_count
    assert_equal_float expected_aggregate_score, @company.aggregate_score

    assert_response 200
  end

  test "should not destroy service review if not signed in" do
    assert_no_difference('Review.count') do
      delete review_url(@review), as: :json
    end

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should destroy service review" do
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
