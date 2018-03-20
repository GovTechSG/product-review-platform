require 'rails_helper'

RSpec.describe ReviewSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    before(:all) do
      @review = create(:product_review)
    end

    subject { ReviewSerializer.new(@review, root: false).as_json["object"].merge("reviewer" => @review.reviewer, "reviewable" => @review.reviewable, "grant" => @review.grant, "strengths" => @review.strengths) }

    it 'has a id' do
      expect(subject['id']).to eql(@review.id)
    end

    it 'has a score' do
      expect(subject['score']).to eql(@review.score)
    end

    it 'has a content' do
      expect(subject['content']).to eql(@review.content)
    end

    it 'has a strengths' do
      expect(subject['strengths']).to eql(@review.strengths)
    end

    it 'has a reviewer' do
      expect(subject['reviewer']).to eql(@review.reviewer)
    end

    it 'has a grant' do
      expect(subject['grant']).to eql(@review.grant)
    end

    it 'has a reviewable' do
      expect(subject['reviewable']).to eql(@review.reviewable)
    end
  end
end
