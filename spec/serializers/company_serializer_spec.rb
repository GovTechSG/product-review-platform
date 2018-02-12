require 'rails_helper'

RSpec.describe CompanySerializer, type: :serializer do
  context 'Individual Resource Representation' do
    before(:all) do
      @company = create(:company)
    end

    subject { CompanySerializer.new(@company, root: false).as_json["object"] }

    it 'has a name' do
      expect(subject['name']).to eql(@company.name)
    end

    it 'has a UEN' do
      expect(subject['UEN']).to eql(@company.UEN)
    end

    it 'has a aggregate score' do
      expect(subject['aggregate_score']).to eql(@company.aggregate_score)
    end

    it 'has a description' do
      expect(subject['description']).to eql(@company.description)
    end
  end
end
