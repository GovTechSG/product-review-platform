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

    it 'has a liker id' do
      expect(subject['liker_id']).to eql(@like.liker_id)
    end

    it 'has a liker type' do
      expect(subject['liker_type']).to eql(@like.liker_type)
    end

    it 'has a likeable type' do
      expect(subject['likeable_type']).to eql(@like.likeable_type)
    end
  end
end
