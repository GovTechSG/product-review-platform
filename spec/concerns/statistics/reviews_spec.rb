require 'rails_helper'

shared_examples_for 'reviews' do
  let(:valid_review) do
    create(:product_review)
  end
  let(:valid_like) do
    build(:product_review_like).attributes
  end
  let(:valid_comment) do
    build(:product_review_comment).attributes
  end

  describe "likes" do
    it "returns 0 with no likes" do
      expect(valid_review.likes_count).to eq(0)
    end
    it "returns number of likes" do
      review = valid_review
      review.likes.create! valid_like
      review.reload
      expect(valid_review.likes_count).to eq(1)
    end
  end
  describe "comments" do
    it "returns 0 with no comments" do
      expect(valid_review.comments_count).to eq(0)
    end
    it "returns number of comments" do
      review = valid_review
      review.comments.create! valid_comment
      review.reload
      expect(valid_review.comments_count).to eq(1)
    end
  end
end
