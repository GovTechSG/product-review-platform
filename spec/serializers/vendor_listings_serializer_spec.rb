require 'rails_helper'

RSpec.describe CompanySerializer, type: :serializer do
  context 'Individual Resource Representation' do
    before(:all) do
      @company = create(:company)
      product = @company.products.create! build(:product).attributes
      product.reviews.create! build(:product_review).attributes
      product.reviews.first.reviewer.industries.create! build(:industry).attributes
    end

    subject do
      VendorListingSerializer.new(@company, root: false).as_json["object"].merge("reviews_count" => @company.reviews_count,
                                                                                 "ratings" => @company.ratings,
                                                                                 "aspects" => @company.aspects,
                                                                                 "industries" => @company.industries,
                                                                                 "project_industries" => @company.project_industries,
                                                                                 "positive" => @company.review_scores.select { |score| score > 0 }.count,
                                                                                 "neutral" => @company.review_scores.select { |score| score == 0 }.count,
                                                                                 "negative" => @company.review_scores.select { |score| score < 0 }.count)
    end
    it 'has a name' do
      expect(subject['name']).to eql(@company.name)
    end

    it 'has a uen' do
      expect(subject['uen']).to eql(@company.uen)
    end

    it 'has a description' do
      expect(subject['description']).to eql(@company.description)
    end

    it 'has a phone_number' do
      expect(subject['phone_number']).to eql(@company.phone_number)
    end

    it 'has a url' do
      expect(subject['url']).to eql(@company.url)
    end

    it 'has a reviews_count' do
      expect(subject['reviews_count']).to eql(@company.reviews_count)
    end

    it 'has a ratings' do
      expect(subject['ratings']).to eql(@company.ratings)
    end

    it 'has a aspects' do
      expect(subject['aspects']).to eql(@company.aspects)
    end

    it 'has a industries' do
      expect(subject['industries']).to eql(@company.industries)
    end

    it 'has project_industries' do
      expect(subject['project_industries'].as_json).to eql(@company.project_industries.as_json)
    end

    it 'has positive' do
      expect(subject['positive']).to eql(@company.review_scores.select { |score| score > 0 }.count)
    end

    it 'has neutral' do
      expect(subject['neutral']).to eql(@company.review_scores.select(&:zero?).count)
    end

    it 'has negative' do
      expect(subject['negative']).to eql(@company.review_scores.select { |score| score < 0 }.count)
    end

    it 'has a image url' do
      expect(subject['image'].url).to eql(@company.image.url)
    end
  end
end
