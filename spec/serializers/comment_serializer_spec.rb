require 'rails_helper'

RSpec.describe CommentSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    before(:all) do
      @comment = create(:product_review_comment)
    end

    subject { CommentSerializer.new(@comment, root: false).as_json["object"] }

    it 'has a content' do
      expect(subject['content']).to eql(@comment.content)
    end

    it 'has a agency' do
      expect(subject['agency_id']).to eql(@comment.agency_id)
    end

    it 'has a review' do
      expect(subject['review_id']).to eql(@comment.review_id)
    end
  end
end
