require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  def setup
    @company = companies(:foo)
  end

  test 'valid company' do
    assert @company.valid?
  end

  test 'invalid without name' do
    @company.name = nil
    refute @company.valid? 'saved company without a name'
    assert_not_nil @company.errors[:name]
  end

  test 'invalid without UEN' do
    @company.UEN = nil
    refute @company.valid? 'saved company without a UEN'
    assert_not_nil @company.errors[:UEN]
  end

  test 'invalid without aggregate_score' do
    @company.aggregate_score = nil
    refute @company.valid? 'saved company without an aggregate_score'
    assert_not_nil @company.errors[:aggregate_score]
  end

  test 'has many reviews' do
    assert_equal 2, @company.reviews.size
  end

  test 'has many products' do
    assert_equal 2, @company.products.size
  end

  test 'has many services' do
    assert_equal 2, @company.services.size
  end
end
