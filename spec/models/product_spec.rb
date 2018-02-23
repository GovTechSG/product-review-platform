require 'rails_helper'
require 'concerns/statistics/products_and_services_spec.rb'
require 'concerns/statistics/companies_spec.rb'

RSpec.describe Product, type: :model do
  it_behaves_like "products_and_services"
  it_behaves_like "companies"
  describe 'validations' do
    it 'has a valid Factory' do
      expect(build(:product)).to be_valid
    end

    it 'is invalid without a name' do
      expect(build(:product, name: nil)).not_to be_valid
    end

    it 'is invalid without a description' do
      expect(build(:product, description: nil)).not_to be_valid
    end

    it 'is invalid without a company' do
      expect(build(:product, company: nil)).not_to be_valid
    end
  end
end
