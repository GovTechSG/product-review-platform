require 'rails_helper'

RSpec.describe Industry, type: :model do
  describe 'validations' do
    it 'has a valid Factory' do
      expect(build(:industry)).to be_valid
    end

    it 'is invalid without a name' do
      expect(build(:industry, name: nil)).not_to be_valid
    end

    it 'is invalid with a duplicate name' do
      industry = create(:industry)
      expect(build(:industry, name: industry.name)).not_to be_valid
    end
  end
end
