require 'rails_helper'

RSpec.describe AspectSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    before(:all) do
      @aspect = create(:aspect)
    end

    subject { AspectSerializer.new(@aspect, root: false).as_json["object"] }

    it 'has a name' do
      expect(subject['name']).to eql(@aspect.name)
    end

    it 'has a description' do
      expect(subject['description']).to eql(@aspect.description)
    end
  end
end