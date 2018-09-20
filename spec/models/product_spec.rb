require 'rails_helper'
require 'concerns/statistics/score_aggregator_spec.rb'

RSpec.describe Product, type: :model do

  describe 'validations' do
    it 'has a valid Factory' do
      expect(build(:product)).to be_valid
    end

    it 'is invalid without a name' do
      expect(build(:product, name: nil)).not_to be_valid
    end

    it "is not valid without a reviews_count" do
      product = build(:product)
      product.reviews_count = nil
      expect(product).to_not be_valid
    end
  end

  describe 'aggregations' do
    it 'updates review count of the company on create' do
      product = create(:product)
      company = product.companies.create! build(:company_as_params)
      expect do
        product.reviews.create!(build(:product_review, vendor_id: company.id).attributes)
      end.to change { product.companies.first.reviews_count }.by(1)
    end

    it 'updates review count of the product on review discard' do
      product = create(:product)
      company = product.companies.create! build(:company_as_params)
      product.reviews.create!(build(:product_review, vendor_id: company.id).attributes)
      product.reviews.create!(build(:product_review, vendor_id: company.id).attributes)
      expect do
        product.reviews.first.discard
      end.to change { product.companies.first.reviews_count }.by(-1)
    end
    it 'returns 0 when there are no reviews' do
      product = create(:product)
      company = product.companies.create! build(:company_as_params)
      product.reviews.create!(build(:product_review, vendor_id: company.id).attributes)
      product.reviews.first.discard
      expect(product.companies.first.reviews_count).to eq(0)
    end
    it 'updates score on product discard' do
      product = create(:product)
      company = product.companies.create! build(:company_as_params)
      product.reviews.create!(build(:product_review, vendor_id: company.id).attributes)
      undiscarded_product = company.products.create!(build(:product).attributes)
      undiscarded_product.reviews.create!(build(:product_review, vendor_id: company.id).attributes)
      product.discard

      expect(company.aggregate_score).to eq(undiscarded_product.aggregate_score)
    end
    it 'returns 0 when there are no score' do
      product = create(:product)
      product.companies.create! build(:company_as_params)
      product.reviews.create!(build(:product_review).attributes)
      product.reviews.first.discard

      expect(product.companies.first.aggregate_score).to eq(0)
    end
  end
end
