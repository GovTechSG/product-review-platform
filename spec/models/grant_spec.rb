require 'rails_helper'

RSpec.describe Grant, type: :model do
  describe 'validations' do
    it 'has a valid Factory' do
      expect(build(:grant)).to be_valid
    end

    it 'is invalid without a name' do
      expect(build(:grant, name: nil)).not_to be_valid
    end

    it 'is invalid with a duplicate name' do
      grant = create(:grant)
      expect(build(:grant, name: grant.name)).not_to be_valid
    end

    it 'is invalid without a description' do
      expect(build(:grant, description: nil)).not_to be_valid
    end

    it 'is invalid without a user' do
      expect(build(:grant, user_id: nil)).not_to be_valid
    end
  end
end
