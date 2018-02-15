require 'rails_helper'

RSpec.describe ProductSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    before(:all) do
      @product = create(:product)
    end

    subject { ProductSerializer.new(@product, root: false).as_json["object"] }

    it 'has a name' do
      expect(subject['name']).to eql(@product.name)
    end

    it 'has a company id' do
      expect(subject['company_id']).to eql(@product.company_id)
    end

    it 'has a description' do
      expect(subject['description']).to eql(@product.description)
    end
  end
end
