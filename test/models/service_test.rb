require 'test_helper'

class ServiceTest < ActiveSupport::TestCase
  def setup
    @service = services(:service_foo)
  end

  test 'valid service' do
    assert @service.valid?
  end

  test 'invalid without name' do
    @service.name = nil
    refute @service.valid? 'saved service without a name'
    assert_not_nil @service.errors[:name]
  end

  test 'invalid without description' do
    @service.description = nil
    refute @service.valid? 'saved service without a description'
    assert_not_nil @service.errors[:description]
  end

  test 'has many reviews' do
    assert_equal 2, @service.reviews.size
  end
end
