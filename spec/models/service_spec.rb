require 'rails_helper'

RSpec.describe Service, type: :model do

  describe 'validations' do
    it 'has a valid Factory' do
      expect(build(:service)).to be_valid
    end

    it 'is invalid without a name' do
      expect(build(:service, name: nil)).not_to be_valid
    end

    it 'is invalid without a description' do
      expect(build(:service, description: nil)).not_to be_valid
    end

    it "is not valid without a reviews_count" do
      service = build(:company)
      service.reviews_count = nil
      expect(service).to_not be_valid
    end

    it 'is invalid without a company' do
      expect(build(:service, company: nil)).not_to be_valid
    end
  end
end