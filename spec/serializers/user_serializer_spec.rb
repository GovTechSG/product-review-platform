require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    before(:all) do
      @user = create(:user)
    end

    subject { UserSerializer.new(@user, root: false).as_json["object"] }

    it 'has a name' do
      expect(subject['name']).to eql(@user.name)
    end

    it 'has a number' do
      expect(subject['number']).to eql(@user.number)
    end

    it 'has a email' do
      expect(subject['email']).to eql(@user.email)
    end
  end
end
