require 'rails_helper'

RSpec.describe CompanySerializer, type: :serializer do
  context 'Individual Resource Representation' do
    before(:all) do
      @company = create(:company)
    end

    subject { CompanySerializer.new(@company, root: false).as_json["object"].merge("reviews_count" => @company.reviews_count, "strengths" => @company.strengths, "industries" => @company.industries) }
    it 'has a name' do
      expect(subject['name']).to eql(@company.name)
    end

    it 'has a uen' do
      expect(subject['uen']).to eql(@company.uen)
    end

    it 'has a aggregate score' do
      expect(subject['aggregate_score']).to eql(@company.aggregate_score)
    end

    it 'has a description' do
      expect(subject['description']).to eql(@company.description)
    end

    it 'has a reviews_count' do
      expect(subject['reviews_count']).to eql(@company.reviews_count)
    end

    it 'has a strengths' do
      expect(subject['strengths']).to eql(@company.strengths)
    end

    it 'has a industries' do
      expect(subject['industries']).to eql(@company.industries)
    end
  end
end
