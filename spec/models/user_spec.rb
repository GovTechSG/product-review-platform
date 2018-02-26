require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    expect(build(:user)).to be_valid
  end
  it "is not valid without a name" do
    user = build(:user)
    user.name = ''
    expect(user).to_not be_valid
  end
  it "is not valid without a number" do
    user = build(:user)
    user.number = ''
    expect(user).to_not be_valid
  end
  it "is not valid without a email" do
    user = build(:user)
    user.email = ''
    expect(user).to_not be_valid
  end
end
