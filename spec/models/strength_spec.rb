require 'rails_helper'

RSpec.describe Strength, type: :model do
  describe 'validations' do
    it 'has a valid Factory' do
      expect(build(:strength)).to be_valid
    end

    it 'is invalid without a name' do
      expect(build(:strength, name: nil)).not_to be_valid
    end

    it 'is invalid with a duplicate name' do
      strength = create(:strength)
      expect(build(:strength, name: strength.name)).not_to be_valid
    end

    it 'is invalid without a description' do
      expect(build(:strength, description: nil)).not_to be_valid
    end
  end
end
