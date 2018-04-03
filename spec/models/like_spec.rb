require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'validations' do
    it "is valid with valid product attributes" do
      expect(build(:product_review_like)).to be_valid
    end
    it "is valid with valid service attributes" do
      expect(build(:service_review_like)).to be_valid
    end
    it "is not valid without a agency" do
      expect(build(:product_review_like, liker_id: nil, liker_type: nil)).to_not be_valid
    end
    it "is not valid without a review" do
      expect(build(:product_review_like, likeable_id: nil, likeable_type: nil)).to_not be_valid
    end
    it "is not valid with a duplicate review_id with the same agency_id" do
      product_review_like = create(:product_review_like)
      expect(build(:product_review_like, likeable: product_review_like.likeable, liker: product_review_like.liker)).to_not be_valid
    end
  end
end