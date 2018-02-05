require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

#Apartment::Tenant.drop( "www" ) rescue nil
#Apartment::Tenant.create( "www" ) rescue nil
#Apartment::Tenant.switch!( "www" )
#Apartment::Tenant.seed

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def assert_not_signed_in_error(body)
    error_msg = "You need to sign in or sign up before continuing."
    assert_equal error_msg, JSON.parse(body)["errors"][0]
  end

  # Modified from http://smsohan.com/blog/2009/04/07/assertequalfloat-assertequal-between/
  def assert_equal_float(expected, actual)
    assert_equal expected.to_f.round(1), actual.to_f.round(1)
  end
end
