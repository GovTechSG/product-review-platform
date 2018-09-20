require 'rails_helper'
require 'concerns/statistics/score_aggregator_spec.rb'

RSpec.describe Service, type: :model do

  describe 'validations' do
    it 'has a valid Factory' do
      expect(build(:service)).to be_valid
    end

    it 'is invalid without a name' do
      expect(build(:service, name: nil)).not_to be_valid
    end

    it "is not valid without a reviews_count" do
      service = build(:service)
      service.reviews_count = nil
      expect(service).to_not be_valid
    end
  end

  describe 'aggregations' do
    it 'updates review count of the company on create' do
      service = create(:service)
      company = service.companies.create! build(:company_as_params)
      expect do
        service.reviews.create!(build(:service_review, vendor_id: company.id).attributes)
      end.to change { service.companies.first.reviews_count }.by(1)
    end

    it 'updates review count of the service on review discard' do
      service = create(:service)
      company = service.companies.create! build(:company_as_params)
      service.reviews.create!(build(:service_review, vendor_id: company.id).attributes)
      service.reviews.create!(build(:service_review, vendor_id: company.id).attributes)
      expect do
        service.reviews.first.discard
      end.to change { service.companies.first.reviews_count }.by(-1)
    end
    it 'returns 0 when there are no reviews' do
      service = create(:service)
      company = service.companies.create! build(:company_as_params)
      service.reviews.create!(build(:service_review, vendor_id: company.id).attributes)
      service.reviews.first.discard
      expect(service.companies.first.reviews_count).to eq(0)
    end
    it 'updates score on service discard' do
      service = create(:service)
      company = service.companies.create! build(:company_as_params)
      service.reviews.create!(build(:service_review, vendor_id: company.id).attributes)
      undiscarded_service = company.services.create!(build(:service).attributes)
      undiscarded_service.reviews.create!(build(:service_review, vendor_id: company.id).attributes)
      service.discard

      expect(company.aggregate_score).to eq(undiscarded_service.aggregate_score)
    end
    it 'returns 0 when there are no score' do
      service = create(:service)
      service.companies.create! build(:company_as_params)
      service.reviews.create!(build(:service_review).attributes)
      service.reviews.first.discard

      expect(service.companies.first.aggregate_score).to eq(0)
    end
  end
end
