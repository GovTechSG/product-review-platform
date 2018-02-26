require 'rails_helper'

RSpec.describe ServiceSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    before(:all) do
      @service = create(:service)
    end

    subject { ServiceSerializer.new(@service, root: false).as_json["object"] }

    it 'has a name' do
      expect(subject['name']).to eql(@service.name)
    end

    it 'has a company id' do
      expect(subject['company_id']).to eql(@service.company_id)
    end

    it 'has a description' do
      expect(subject['description']).to eql(@service.description)
    end
  end
end
