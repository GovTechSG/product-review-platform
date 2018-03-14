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
  it "is valid without a number" do
    user = build(:user)
    user.number = ''
    expect(user).to be_valid
  end
  it "is valid without a email" do
    user = build(:user)
    user.email = ''
    expect(user).to be_valid
  end
  it 'is invalid with a duplicate name' do
    user = build(:user)
    user.save
    expect(build(:user, name: user.name)).not_to be_valid
  end
end
