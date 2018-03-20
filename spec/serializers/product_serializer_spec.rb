require 'rails_helper'

RSpec.describe ProductSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    before(:all) do
      @product = create(:product)
    end

    subject { ProductSerializer.new(@product, root: false).as_json["object"].merge("company" => @product.company) }

    it 'has a name' do
      expect(subject['name']).to eql(@product.name)
    end

    it 'has a company' do
      expect(subject['company']).to eql(@product.company)
    end

    it 'has a reviews_count' do
      expect(subject['reviews_count']).to eql(@product.reviews_count)
    end

    it 'has a description' do
      expect(subject['description']).to eql(@product.description)
    end
  end
end
