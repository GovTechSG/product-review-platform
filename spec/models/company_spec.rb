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
  it "is not valid without a uen" do
    company = build(:company)
    company.uen = ''
    expect(company).to_not be_valid
  end
  it "is not valid without a aggregate_score" do
    company = build(:company)
    company.aggregate_score = ''
    expect(company).to_not be_valid
  end
  it 'is invalid with a duplicate uen' do
    company = build(:company)
    company.save
    expect(build(:company, uen: company.uen)).not_to be_valid
  end
  it 'is invalid with a duplicate name' do
    company = build(:company)
    company.save
    expect(build(:company, name: company.name)).not_to be_valid
  end
  it "is valid without a url" do
    company = build(:company)
    company.url = ''
    expect(company).to be_valid
  end
  it "is not valid with an invalid url" do
    company = build(:company)
    company.url = 'hey'
    expect(company).to_not be_valid
  end

  it "is valid with a valid url" do
    company = build(:company)
    expect(company).to be_valid
  end
end
