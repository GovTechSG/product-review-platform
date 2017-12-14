require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @comment = comments(:one)
  end

  test 'valid comment' do
    assert @comment.valid?
  end

  test 'invalid without content' do
    @comment.content = nil
    refute @comment.valid? 'saved comment without content'
    assert_not_nil @comment.errors[:content]
  end
end
