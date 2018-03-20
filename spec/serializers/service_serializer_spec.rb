require 'rails_helper'

RSpec.describe ServiceSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    before(:all) do
      @service = create(:service)
    end

    subject { ServiceSerializer.new(@service, root: false).as_json["object"].merge("company" => @service.company) }

    it 'has a name' do
      expect(subject['name']).to eql(@service.name)
    end

    it 'has a company' do
      expect(subject['company']).to eql(@service.company)
    end

    it 'has a reviews_count' do
      expect(subject['reviews_count']).to eql(@service.reviews_count)
    end

    it 'has a description' do
      expect(subject['description']).to eql(@service.description)
    end
  end
end
