require 'rails_helper'

RSpec.describe Company, type: :model do
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
  it "is not valid with an aggregate_score below 0" do
    company = build(:company)
    company.aggregate_score = -1
    expect(company).to_not be_valid
  end
  it "is not valid with an aggregate_score above 5" do
    company = build(:company)
    company.aggregate_score = 5.1
    expect(company).to_not be_valid
  end
end
