require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @like = likes(:one)
    @review = @like.review
    @auth_headers = users(:one).create_new_auth_token
  end

  test "should not get index if not signed in" do
    get review_likes_url(@review.id), as: :json

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should get index" do
    get review_likes_url(@review.id), headers: @auth_headers, as: :json

    assert_response :success

    likes = @review.likes
    expected = likes.as_json
    # Call :agency method for each like
    expected.each_with_index do |like, idx|
      like["agency"] = likes[idx].agency
    end
    assert_equal expected.to_json, response.body
  end

  test "should not create like if not signed in" do
    like = { agency_id: agencies(:two).id }
    assert_no_difference('Like.count') do
      post review_likes_url(@review.id), params: { like: like }, as: :json
    end

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should create like" do
    like = { agency_id: agencies(:two).id }
    # assert_difference('Like.count') do
      post review_likes_url(@review.id), params: { like: like }, headers: @auth_headers, as: :json
    # end

    assert_response 201
  end

  test "should not show like if not signed in" do
    get like_url(@like), as: :json

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should show like" do
    get like_url(@like), headers: @auth_headers, as: :json

    assert_response :success
    assert_equal @like.to_json, response.body
  end

  test "should not destroy like if not signed in" do
    assert_no_difference('Like.count') do
      delete like_url(@like), as: :json
    end

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should destroy like" do
    assert_difference('Like.count', -1) do
      delete like_url(@like), headers: @auth_headers, as: :json
    end

    assert_response 204
  end
end
