require 'rails_helper'

RSpec.describe GrantSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    before(:all) do
      @grant = create(:grant)
    end

    subject { GrantSerializer.new(@grant, root: false).as_json["object"].merge("user" => @grant.user) }

    it 'has a name' do
      expect(subject['name']).to eql(@grant.name)
    end

    it 'has a description' do
      expect(subject['description']).to eql(@grant.description)
    end

    it 'has a acronym' do
      expect(subject['acronym']).to eql(@grant.acronym)
    end

    it 'has a user' do
      expect(subject['user']).to eql(@grant.user)
    end
  end
end