require 'rails_helper'

RSpec.describe StrengthSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    before(:all) do
      @strength = create(:strength)
    end

    subject { StrengthSerializer.new(@strength, root: false).as_json["object"] }

    it 'has a name' do
      expect(subject['name']).to eql(@strength.name)
    end

    it 'has a description' do
      expect(subject['description']).to eql(@strength.description)
    end
  end
end