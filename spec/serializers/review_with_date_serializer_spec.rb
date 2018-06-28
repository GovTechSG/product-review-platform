require 'rails_helper'

RSpec.describe ReviewWithDateSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    before(:all) do
      @review = create(:product_review)
    end

    subject { ReviewWithDateSerializer.new(@review, root: false).as_json["object"].merge("reviewer" => @review.reviewer, "reviewable" => @review.reviewable, "grant" => @review.grant, "aspects" => @review.aspects) }

    it 'has a id' do
      expect(subject['id']).to eql(@review.id)
    end

    it 'has a score' do
      expect(subject['score']).to eql(@review.score)
    end

    it 'has a content' do
      expect(subject['content']).to eql(@review.content)
    end

    it 'has a aspects' do
      expect(subject['aspects']).to eql(@review.aspects)
    end

    it 'has a reviewer' do
      expect(subject['reviewer']).to eql(@review.reviewer)
    end

    it 'has a grant' do
      expect(subject['grant']).to eql(@review.grant)
    end

    it 'has a created_at' do
      expect(subject['created_at']).to eql(@review.created_at)
    end

    it 'has a reviewable' do
      expect(subject['reviewable']).to eql(@review.reviewable)
    end
  end
end
