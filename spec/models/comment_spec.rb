require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validations' do
    it 'has a valid product review comment Factory' do
      expect(build(:product_review_comment)).to be_valid
    end

    it 'is invalid without a content for product_review_comment' do
      expect(build(:product_review_comment, content: nil)).not_to be_valid
    end

    it 'is invalid without a commenter for product_review_comment' do
      expect(build(:product_review_comment, commenter: nil)).not_to be_valid
    end

    it 'is invalid without a commentable for product_review_comment' do
      expect(build(:product_review_comment, commentable: nil)).not_to be_valid
    end

    it 'has a valid service review comment Factory' do
      expect(build(:service_review_comment)).to be_valid
    end

    it 'is invalid without a content for service_review_comment' do
      expect(build(:service_review_comment, content: nil)).not_to be_valid
    end

    it 'is invalid without a commenter for service_review_comment' do
      expect(build(:service_review_comment, commenter: nil)).not_to be_valid
    end

    it 'is invalid without a commentable for service_review_comment' do
      expect(build(:service_review_comment, commentable: nil)).not_to be_valid
    end
  end
end