require 'rails_helper'

shared_examples_for 'score_aggregator' do
  let(:valid_company) do
    create(:company, aggregate_score: 0)
  end

  describe "calculate_aggregate_score" do
    it "passes in a list of reviews and gets a double between 0 - 10" do
      valid_company
      company = Company.first
      expect(company.aggregate_score).to eq(0.0)
      product = company.products.create!(build(:product).attributes)
      expect(product.companies.first.aggregate_score).to eq(0.0)
      expect(product.companies.first.products.first.aggregate_score).to eq(0.0)
      company.products.first.reviews.create!(build(:product_review, vendor_id: company.id).attributes)
      company.products.first.reviews.create!(build(:product_review, vendor_id: company.id).attributes)
      company.products.first.reviews.create!(build(:product_review, vendor_id: company.id).attributes)
      company.products.first.reviews.create!(build(:product_review, vendor_id: company.id).attributes)
      company.products.first.reviews.create!(build(:product_review, vendor_id: company.id).attributes)
      review = company.products.first.reviews.create!(build(:product_review, vendor_id: company.id).attributes)

      expect(review.reviewable.companies.first.aggregate_score).to_not eq(0.0)
      expect(review.reviewable.companies.first.products.first.aggregate_score).to_not eq(0.0)
    end
  end
end