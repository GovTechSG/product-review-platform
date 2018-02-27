require 'rails_helper'

RSpec.describe Industry, type: :model do
  describe 'validations' do
    it 'has a valid Factory' do
      expect(build(:industry)).to be_valid
    end

    it 'is invalid without a name' do
      expect(build(:product, name: nil)).not_to be_valid
    end
  end
end
