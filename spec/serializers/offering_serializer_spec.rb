require 'rails_helper'

RSpec.describe OfferingSerializer, type: :serializer do
  context 'product' do
    before(:all) do
      @product = create(:product)
    end

    subject { OfferingSerializer.new(@product, root: false).as_json["object"] }

    it 'has a name' do
      expect(subject['name']).to eql(@product.name)
    end

    it 'has a description' do
      expect(subject['description']).to eql(@product.description)
    end
  end
  context 'service' do
    before(:all) do
      @service = create(:service)
    end

    subject { OfferingSerializer.new(@service, root: false).as_json["object"] }

    it 'has a name' do
      expect(subject['name']).to eql(@service.name)
    end

    it 'has a description' do
      expect(subject['description']).to eql(@service.description)
    end
  end
  context 'project' do
    before(:all) do
      @project = create(:project)
    end

    subject { OfferingSerializer.new(@project, root: false).as_json["object"] }

    it 'has a name' do
      expect(subject['name']).to eql(@project.name)
    end

    it 'has a description' do
      expect(subject['description']).to eql(@project.description)
    end
  end
end
