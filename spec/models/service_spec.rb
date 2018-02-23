require 'rails_helper'
require 'concerns/statistics/products_and_services_spec.rb'
require 'concerns/statistics/companies_spec.rb'

RSpec.describe Service, type: :model do
  it_behaves_like "products_and_services"
  it_behaves_like "companies"
end