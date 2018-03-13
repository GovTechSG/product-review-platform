require 'rails_helper'

RSpec.describe Agency, type: :model do
  it "is valid with valid attributes" do
    expect(build(:agency)).to be_valid
  end
  it "is not valid without a name" do
    agency = build(:agency)
    agency.name = ''
    expect(agency).to_not be_valid
  end
  it "is not valid without a number" do
    agency = build(:agency)
    agency.number = ''
    expect(agency).to_not be_valid
  end
  it "is not valid without a email" do
    agency = build(:agency)
    agency.email = ''
    expect(agency).to_not be_valid
  end
end
