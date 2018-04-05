require 'rails_helper'

RSpec.describe Aspect, type: :model do
  describe 'validations' do
    it 'has a valid Factory' do
      expect(build(:aspect)).to be_valid
    end

    it 'is invalid without a name' do
      expect(build(:aspect, name: nil)).not_to be_valid
    end

    it 'is invalid with a duplicate name' do
      aspect = create(:aspect)
      expect(build(:aspect, name: aspect.name)).not_to be_valid
    end

    it 'is invalid without a description' do
      expect(build(:aspect, description: nil)).not_to be_valid
    end
  end
end
