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

  describe 'aggregations' do
    context 'product' do
      it 'updates review count of the product on create' do
        product = create(:product)
        expect do
          product.reviews.create!(build(:product_review).attributes)
        end.to change { product.reviews_count }.by(1)
      end

      it 'updates score of the product on create' do
        product = create(:product)
        review_one = product.reviews.create!(build(:product_review).attributes)
        review_two = product.reviews.create!(build(:product_review).attributes)
        expect(product.aggregate_score).to eq((review_one.score + review_two.score) / 2.0)
      end

      it 'updates review count of the product on discard' do
        product = create(:product)
        product.reviews.create!(build(:product_review).attributes)
        product.reviews.create!(build(:product_review).attributes)
        expect do
          product.reviews.first.discard
        end.to change { product.reviews_count }.by(-1)
      end
      it 'returns 0 when there are no reviews' do
        product = create(:product)
        product.reviews.create!(build(:product_review).attributes)
        product.reviews.first.discard
        expect(product.reviews_count).to eq(0)
      end
      it 'updates score on discard' do
        product = create(:product)
        product.reviews.create!(build(:product_review).attributes)
        undiscarded_review = product.reviews.create!(build(:product_review).attributes)
        product.reviews.first.discard
  
        expect(product.aggregate_score).to eq(undiscarded_review.score)
      end
      it 'returns 0 when there are no score' do
        product = create(:product)
        product.reviews.create!(build(:product_review).attributes)
        product.reviews.first.discard
  
        expect(product.aggregate_score).to eq(0)
      end
    end

    context 'service' do
      it 'updates review count of the service on create' do
        service = create(:service)
        expect do
          service.reviews.create!(build(:service_review).attributes)
        end.to change { service.reviews_count }.by(1)
      end

      it 'updates score of the service on create' do
        service = create(:service)
        review_one = service.reviews.create!(build(:service_review).attributes)
        review_two = service.reviews.create!(build(:service_review).attributes)
        expect(service.aggregate_score).to eq((review_one.score + review_two.score) / 2.0)
      end

      it 'updates review count of the service on discard' do
        service = create(:service)
        service.reviews.create!(build(:service_review).attributes)
        service.reviews.create!(build(:service_review).attributes)
        expect do
          service.reviews.first.discard
        end.to change { service.reviews_count }.by(-1)
      end
      it 'returns 0 when there are no reviews' do
        service = create(:service)
        service.reviews.create!(build(:service_review).attributes)
        service.reviews.first.discard
        expect(service.reviews_count).to eq(0)
      end
      it 'updates score on discard' do
        service = create(:service)
        service.reviews.create!(build(:service_review).attributes)
        undiscarded_review = service.reviews.create!(build(:service_review).attributes)
        service.reviews.first.discard
  
        expect(service.aggregate_score).to eq(undiscarded_review.score)
      end
      it 'returns 0 when there are no score' do
        service = create(:service)
        service.reviews.create!(build(:service_review).attributes)
        service.reviews.first.discard
  
        expect(service.aggregate_score).to eq(0)
      end
    end

    context 'project' do
      it 'updates review count of the project on create' do
        project = create(:project)
        expect do
          project.reviews.create!(build(:project_review).attributes)
        end.to change { project.reviews_count }.by(1)
      end

      it 'updates score of the project on create' do
        project = create(:project)
        review_one = project.reviews.create!(build(:project_review).attributes)
        review_two = project.reviews.create!(build(:project_review).attributes)
        expect(project.aggregate_score).to eq((review_one.score + review_two.score) / 2.0)
      end

      it 'updates review count of the project on discard' do
        project = create(:project)
        project.reviews.create!(build(:project_review).attributes)
        project.reviews.create!(build(:project_review).attributes)
        expect do
          project.reviews.first.discard
        end.to change { project.reviews_count }.by(-1)
      end
      it 'returns 0 when there are no reviews' do
        project = create(:project)
        project.reviews.create!(build(:project_review).attributes)
        project.reviews.first.discard
        expect(project.reviews_count).to eq(0)
      end
      it 'updates score on discard' do
        project = create(:project)
        project.reviews.create!(build(:project_review).attributes)
        undiscarded_review = project.reviews.create!(build(:project_review).attributes)
        project.reviews.first.discard
  
        expect(project.aggregate_score).to eq(undiscarded_review.score)
      end
      it 'returns 0 when there are no score' do
        project = create(:project)
        project.reviews.create!(build(:project_review).attributes)
        project.reviews.first.discard
  
        expect(project.aggregate_score).to eq(0)
      end
    end
  end
end