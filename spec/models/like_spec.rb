require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'validations' do
    it "is valid with valid product attributes" do
      expect(build(:product_review_like)).to be_valid
    end
    it "is valid with valid service attributes" do
      expect(build(:service_review_like)).to be_valid
    end
    it "is not valid without a user" do
      expect(build(:product_review_like, user: nil)).to_not be_valid
    end
    it "is not valid without a review" do
      expect(build(:product_review_like, review: nil)).to_not be_valid
    end
    it "is not valid with a duplicate review_id with the same user_id" do
      product_review_like = create(:product_review_like)
      expect(build(:product_review_like, review: product_review_like.review, user: product_review_like.user)).to_not be_valid
    end
  end
end