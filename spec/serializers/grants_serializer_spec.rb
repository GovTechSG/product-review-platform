require 'rails_helper'

RSpec.describe GrantSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    before(:all) do
      @grant = create(:grant)
    end

    subject { GrantSerializer.new(@grant, root: false).as_json["object"] }

    it 'has a name' do
      expect(subject['name']).to eql(@grant.name)
    end
  end
end