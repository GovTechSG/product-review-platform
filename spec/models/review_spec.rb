require 'rails_helper'
require 'concerns/statistics/reviews_spec.rb'

RSpec.describe Review, type: :model do
  it_behaves_like "reviews"

  describe 'validations' do
    it 'has a valid product Factory' do
      expect(build(:product_review)).to be_valid
    end

    it 'has a valid service Factory' do
      expect(build(:service_review)).to be_valid
    end

    it 'is invalid without a score' do
      expect(build(:product_review, score: nil)).not_to be_valid
    end

    it 'is valid without a content' do
      expect(build(:product_review, content: nil)).to be_valid
    end

    it 'is invalid without a company' do
      expect(build(:product_review, reviewer: nil)).not_to be_valid
    end

    it 'is invalid without a reviewable' do
      expect(build(:product_review, reviewable: nil)).not_to be_valid
    end

    it 'is invalid without a grant' do
      expect(build(:product_review, grant: nil)).not_to be_valid
    end
  end
end