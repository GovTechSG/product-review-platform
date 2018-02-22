require 'rails_helper'

RSpec.describe ReviewSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    before(:all) do
      @review = create(:product_review)
    end

    subject { ReviewSerializer.new(@review, root: false).as_json["object"] }

    it 'has a id' do
      expect(subject['id']).to eql(@review.id)
    end

    it 'has a score' do
      expect(subject['score']).to eql(@review.score)
    end

    it 'has a content' do
      expect(subject['content']).to eql(@review.content)
    end

    it 'has a reviewable id' do
      expect(subject['reviewable_id']).to eql(@review.reviewable_id)
    end

    it 'has a reviewable type' do
      expect(subject['reviewable_type']).to eql(@review.reviewable_type)
    end

    it 'has a strengths' do
      expect(subject['strengths']).to eql(@review.strengths)
    end

    it 'has a company id' do
      expect(subject['company_id']).to eql(@review.company_id)
    end
  end
end
