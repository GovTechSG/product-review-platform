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

    it 'has a commenter' do
      expect(subject['commenter_id']).to eql(@comment.commenter_id)
    end

    it 'has a commentable' do
      expect(subject['commentable_id']).to eql(@comment.commentable_id)
    end
  end
end
