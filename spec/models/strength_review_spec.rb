require 'rails_helper'

RSpec.describe StrengthReview, type: :model do
  describe 'validations' do
    it 'has a valid Factory' do
      expect(build(:product_strength_review)).to be_valid
      expect(build(:service_strength_review)).to be_valid
    end

    it 'is invalid without a strength_id' do
      expect(build(:strength_review, strength_id: nil)).not_to be_valid
    end
    it 'is invalid without a review_id' do
      expect(build(:strength_review, review_id: nil)).not_to be_valid
    end
  end
end
