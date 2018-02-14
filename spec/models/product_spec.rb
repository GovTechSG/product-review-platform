require 'rails_helper'

RSpec.describe Product, type: :model do
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
