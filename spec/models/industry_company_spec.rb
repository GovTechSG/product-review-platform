require 'rails_helper'

RSpec.describe Industry, type: :model do
  describe 'validations' do
    it 'has a valid Factory' do
      expect(build(:industry_company)).to be_valid
    end

    it 'is invalid without a industry_id' do
      expect(build(:industry_company, industry_id: nil)).not_to be_valid
    end
    it 'is invalid without a company_id' do
      expect(build(:industry_company, company_id: nil)).not_to be_valid
    end
  end
end
