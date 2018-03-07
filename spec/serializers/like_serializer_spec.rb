require 'rails_helper'

RSpec.describe LikeSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    before(:all) do
      @like = create(:product_review_like)
    end

    subject { LikeSerializer.new(@like, root: false).as_json["object"] }

    it 'has a id' do
      expect(subject['id']).to eql(@like.id)
    end

    it 'has a user id' do
      expect(subject['user_id']).to eql(@like.user_id)
    end

    it 'has a review id' do
      expect(subject['review_id']).to eql(@like.review_id)
    end
  end
end
