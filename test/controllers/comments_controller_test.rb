require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @comment = comments(:one)
    @review = @comment.review
    @auth_headers = users(:one).create_new_auth_token
  end

  test "should not get index if not signed in" do
    get review_comments_url(@review.id), as: :json

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should get index" do
    get review_comments_url(@review.id), headers: @auth_headers, as: :json

    assert_response :success

    comments = @review.comments
    expected = comments.as_json
    # Call :agency method for each comment
    expected.each_with_index do |comment, idx|
      comment["agency"] = comments[idx].agency
    end
    assert_equal expected.to_json, response.body
  end

  test "should not create comment if not signed in" do
    comment = {
      content: "Some comment here",
      agency_id: agencies(:three).id,
      review_id: reviews(:pivotal_tracker_review_one).id
    }
    assert_no_difference('Comment.count') do
      post review_comments_url(@review.id), params: { comment: comment }, as: :json
    end

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should create comment" do
    comment = {
      content: "Some comment here",
      agency_id: agencies(:three).id
    }
    assert_difference('Comment.count') do
      post review_comments_url(@review.id), params: { comment: comment }, headers: @auth_headers, as: :json
    end

    assert_response 201
  end

  test "should not show comment if not signed in" do
    get comment_url(@comment), as: :json

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should show comment" do
    get comment_url(@comment), headers: @auth_headers, as: :json

    assert_response :success
    assert_equal @comment.to_json, response.body
  end

  test "should not update comment if not signed in" do
    current = { content: @comment.content }
    updated = { content: "New content" }
    patch comment_url(@comment), params: { comment: updated }, as: :json

    # Assert unchanged
    @comment.reload
    assert_equal current[:content], @comment.content

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should update comment" do
    updated = { content: "New content" }
    patch comment_url(@comment), params: { comment: updated }, headers: @auth_headers, as: :json

    @comment.reload
    assert_equal updated[:content], @comment.content

    assert_response 200
  end

  test "should not destroy comment if not signed in" do
    assert_no_difference('Comment.count') do
      delete comment_url(@comment), as: :json
    end

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should destroy comment" do
    assert_difference('Comment.count', -1) do
      delete comment_url(@comment), headers: @auth_headers, as: :json
    end

    assert_response 204
  end
end
