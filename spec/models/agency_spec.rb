require 'rails_helper'

RSpec.describe Agency, type: :model do
  it_behaves_like "imageable"
  it "is valid with valid attributes" do
    expect(build(:agency)).to be_valid
  end
  it "is not valid without a name" do
    agency = build(:agency)
    agency.name = ''
    expect(agency).to_not be_valid
  end
  it "is not valid without a acronym" do
    agency = build(:agency)
    agency.acronym = ''
    expect(agency).to_not be_valid
  end
  it "is not valid without a kind" do
    agency = build(:agency)
    agency.kind = ''
    expect(agency).to_not be_valid
  end
  it "is not valid without a description" do
    agency = build(:agency)
    agency.description = ''
    expect(agency).to_not be_valid
  end
  it "is valid without a phone_number" do
    agency = build(:agency)
    agency.phone_number = ''
    expect(agency).to be_valid
  end
  it "is valid without a email" do
    agency = build(:agency)
    agency.email = ''
    expect(agency).to be_valid
  end
  it "is not valid with an invalid email" do
    agency = build(:agency)
    agency.email = 'hey'
    expect(agency).to_not be_valid
  end

  it "is valid with a valid email" do
    agency = build(:agency)
    expect(agency).to be_valid
  end
end
