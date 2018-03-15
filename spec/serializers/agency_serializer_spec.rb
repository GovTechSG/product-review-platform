require 'rails_helper'

RSpec.describe AgencySerializer, type: :serializer do
  context 'Individual Resource Representation' do
    before(:all) do
      @agency = create(:agency)
    end

    subject { AgencySerializer.new(@agency, root: false).as_json["object"] }

    it 'has a name' do
      expect(subject['name']).to eql(@agency.name)
    end

    it 'has a number' do
      expect(subject['number']).to eql(@agency.number)
    end

    it 'has a email' do
      expect(subject['email']).to eql(@agency.email)
    end
    it 'has a acronym' do
      expect(subject['acronym']).to eql(@agency.acronym)
    end
    it 'has a kind' do
      expect(subject['kind']).to eql(@agency.kind)
    end
    it 'has a description' do
      expect(subject['description']).to eql(@agency.description)
    end
  end
end
