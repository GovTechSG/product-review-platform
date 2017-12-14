require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  def setup
    @review = reviews(:pivotal_tracker_review_one)
  end

  test 'valid review' do
    assert @review.valid?
  end

  test 'invalid without score' do
    @review.score = nil
    refute @review.valid? 'saved review without a score'
    assert_not_nil @review.errors[:score]
  end

  test 'invalid without content' do
    @review.content = nil
    refute @review.valid? 'saved review without content'
    assert_not_nil @review.errors[:content]
  end

  test 'has many likes' do
    assert_equal 2, @review.likes.size
  end

  test 'has many comments' do
    assert_equal 2, @review.comments.size
  end
end
