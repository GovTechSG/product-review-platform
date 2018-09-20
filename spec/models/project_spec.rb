require 'rails_helper'
require 'concerns/statistics/score_aggregator_spec.rb'

RSpec.describe Project, type: :model do

  describe 'validations' do
    it 'has a valid Factory' do
      expect(build(:project)).to be_valid
    end

    it 'is invalid without a name' do
      expect(build(:project, name: nil)).not_to be_valid
    end

    it "is not valid without a reviews_count" do
      project = build(:project)
      project.reviews_count = nil
      expect(project).to_not be_valid
    end
  end

  describe 'aggregations' do
    it 'updates review count of the company on create' do
      project = create(:project)
      company = project.companies.create! build(:company_as_params)
      expect do
        project.reviews.create!(build(:project_review, vendor_id: company.id).attributes)
      end.to change { project.companies.first.reviews_count }.by(1)
    end

    it 'updates review count of the project on review discard' do
      project = create(:project)
      company = project.companies.create! build(:company_as_params)
      project.reviews.create!(build(:project_review, vendor_id: company.id).attributes)
      project.reviews.create!(build(:project_review, vendor_id: company.id).attributes)
      expect do
        project.reviews.first.discard
      end.to change { project.companies.first.reviews_count }.by(-1)
    end
    it 'returns 0 when there are no reviews' do
      project = create(:project)
      company = project.companies.create! build(:company_as_params)
      project.reviews.create!(build(:project_review, vendor_id: company.id).attributes)
      project.reviews.first.discard
      expect(project.companies.first.reviews_count).to eq(0)
    end
    it 'updates score on project discard' do
      project = create(:project)
      company = project.companies.create! build(:company_as_params)
      project.reviews.create!(build(:project_review, vendor_id: company.id).attributes)
      undiscarded_project = company.projects.create!(build(:project).attributes)
      undiscarded_project.reviews.create!(build(:project_review, vendor_id: company.id).attributes)
      project.discard

      expect(company.aggregate_score).to eq(undiscarded_project.aggregate_score)
    end
    it 'returns 0 when there are no score' do
      project = create(:project)
      project.companies.create! build(:company_as_params)
      project.reviews.create!(build(:project_review).attributes)
      project.reviews.first.discard

      expect(project.companies.first.aggregate_score).to eq(0)
    end
  end
end
