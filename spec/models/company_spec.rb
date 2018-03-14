require 'rails_helper'
require 'concerns/statistics/companies_spec.rb'

RSpec.describe Company, type: :model do
  it_behaves_like "companies"
  it "is valid with valid attributes" do
    expect(build(:company)).to be_valid
  end
  it "is not valid without a name" do
    company = build(:company)
    company.name = ''
    expect(company).to_not be_valid
  end
  it "is not valid without a description" do
    company = build(:company)
    company.description = ''
    expect(company).to_not be_valid
  end
  it "is not valid without a UEN" do
    company = build(:company)
    company.UEN = ''
    expect(company).to_not be_valid
  end
  it "is not valid without a aggregate_score" do
    company = build(:company)
    company.aggregate_score = ''
    expect(company).to_not be_valid
  end
  it 'is invalid with a duplicate UEN' do
    company = build(:company)
    company.save
    expect(build(:company, UEN: company.UEN)).not_to be_valid
  end
  it 'is invalid with a duplicate name' do
    company = build(:company)
    company.save
    expect(build(:company, name: company.name)).not_to be_valid
  end
end
