require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  def setup
    @product = products(:pivotal_tracker)
  end

  test 'valid product' do
    assert @product.valid?
  end

  test 'invalid without name' do
    @product.name = nil
    refute @product.valid? 'saved product without a name'
    assert_not_nil @product.errors[:name]
  end

  test 'invalid without description' do
    @product.description = nil
    refute @product.valid? 'saved product without a description'
    assert_not_nil @product.errors[:description]
  end

  test 'has many reviews' do
    assert_equal 2, @product.reviews.size
  end
end
