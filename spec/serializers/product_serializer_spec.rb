require 'rails_helper'

RSpec.describe ProductSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    before(:all) do
      @product = create(:product)
      @product.companies.create!(build(:company_as_params))
    end

    subject { ProductSerializer.new(@product, root: false).as_json["object"].merge("companies" => @product.companies) }

    it 'has a name' do
      expect(subject['name']).to eql(@product.name)
    end

    it 'has companies' do
      expect(subject['companies']).to eql(@product.companies)
    end

    it 'has a reviews_count' do
      expect(subject['reviews_count']).to eql(@product.reviews_count)
    end

    it 'has a description' do
      expect(subject['description']).to eql(@product.description)
    end
  end
end
