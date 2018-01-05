require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  def setup
    @like = likes(:one)
    @like_two = likes(:two)
  end

  test 'valid like' do
    assert @like.valid?
  end

  test 'invalid if existing like has the same review and agency' do
    @like.review_id = @like_two.review.id
    refute @like.valid? "saved like with existing like's review and agency"
    assert_not_nil @like.errors[:agency_id]
  end
end
