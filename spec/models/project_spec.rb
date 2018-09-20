require 'rails_helper'

RSpec.describe Project, type: :model do

  describe 'validations' do
    it 'has a valid Factory' do
      expect(build(:project)).to be_valid
    end

    it 'is invalid without a name' do
      expect(build(:project, name: nil)).not_to be_valid
    end

    it "is not valid without a reviews_count" do
      project = build(:company)
      project.reviews_count = nil
      expect(project).to_not be_valid
    end

    it 'is invalid without a company' do
      expect(build(:project, company: nil)).not_to be_valid
    end
  end
end