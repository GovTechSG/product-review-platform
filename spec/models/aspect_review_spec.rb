require 'rails_helper'

RSpec.describe AspectReview, type: :model do
  describe 'validations' do
    it 'has a valid Factory' do
      expect(build(:product_aspect_review)).to be_valid
      expect(build(:service_aspect_review)).to be_valid
    end

    it 'is invalid without a aspect_id' do
      expect(build(:aspect_review, aspect_id: nil)).not_to be_valid
    end
    it 'is invalid without a review_id' do
      expect(build(:aspect_review, review_id: nil)).not_to be_valid
    end
  end
end
