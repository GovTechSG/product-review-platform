require 'test_helper'

class AgencyTest < ActiveSupport::TestCase
  def setup
    @agency = agencies(:one)
  end

  test 'valid agency' do
    assert @agency.valid?
  end

  test 'invalid without name' do
    @agency.name = nil
    refute @agency.valid? 'saved agency without a name'
    assert_not_nil @agency.errors[:name]
  end

  test 'invalid without email' do
    @agency.email = nil
    refute @agency.valid? 'saved agency without a email'
    assert_not_nil @agency.errors[:email]
  end

  test 'invalid without number' do
    @agency.number = nil
    refute @agency.valid? 'saved agency without an aggregate_score'
    assert_not_nil @agency.errors[:number]
  end

  test 'has many likes' do
    assert_equal 2, @agency.likes.size
  end

  test 'has many comments' do
    assert_equal 2, @agency.comments.size
  end
end
