require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @comment = comments(:one)
    @review = @comment.review
  end

  test "should get index" do
    get review_comments_url(@review.id), as: :json

    assert_response :success
    assert_equal @review.comments.to_json, response.body
  end

  test "should create comment" do
    comment = {
      content: "Some comment here",
      agency_id: agencies(:three).id,
      review_id: reviews(:pivotal_tracker_review_one).id
    }
    assert_difference('Comment.count') do
      post review_comments_url(@review.id), params: { comment: comment }, as: :json
    end

    assert_response 201
  end

  test "should show comment" do
    get comment_url(@comment), as: :json

    assert_response :success
    assert_equal @comment.to_json, response.body
  end

  test "should update comment" do
    updated = { content: "New content" }
    patch comment_url(@comment), params: { comment: updated }, as: :json
    assert_response 200
  end

  test "should destroy comment" do
    assert_difference('Comment.count', -1) do
      delete comment_url(@comment), as: :json
    end

    assert_response 204
  end
end
