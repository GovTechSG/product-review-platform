require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Likes", type: :request do
  let(:valid_attributes) do
    build(:product_review_like).attributes
  end

  let(:invalid_attributes) do
    build(:product_review_like, review_id: nil, user_id: nil).attributes
  end

  let(:valid_session) {}

  describe "Authorised user" do
    describe "GET api/v1/reviews/:review_id/likes" do
      it "returns a success response" do
        like = Like.create! valid_attributes
        get review_likes_path(like.review.id), headers: request_login

        expect(response).to be_success
      end
    end

    describe "GET api/v1/likes/:id" do
      it "returns a success response" do
        like = Like.create! valid_attributes
        get like_path(like.id), headers: request_login
        expect(response).to be_success
      end

      it "returns not found when like not found" do
        get like_path(0), headers: request_login
        expect(response).to be_not_found
      end
    end

    describe "POST api/v1/reviews/:review_id/likes" do
      context "with valid params" do
        it "creates a new Like" do
          review = create(:product_review)

          expect do
            post review_likes_path(review.id), params: { like: valid_attributes }, headers: request_login
          end.to change(Like, :count).by(1)
        end

        it "renders a JSON response with the new like" do
          review = create(:product_review)

          post review_likes_path(review.id), params: { like: valid_attributes }, headers: request_login
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(like_url(Like.last))
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the new like" do
          review = create(:product_review)
          post review_likes_path(review.id), params: { like: invalid_attributes }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "DELETE api/v1/likes/:id" do
      it "soft deletes" do
        like = Like.create! valid_attributes
        expect do
          delete like_path(like.id), headers: request_login
        end.to change(Like, :count).by(0)
      end

      it "sets discarded_at datetime" do
        like = Like.create! valid_attributes
        delete like_path(like.id), headers: request_login
        like.reload
        expect(like.discarded?).to be true
      end

      it "renders a JSON response with the like" do
        like = Like.create! valid_attributes

        delete like_path(like.id), headers: request_login
        expect(response).to have_http_status(204)
      end

      it "returns a not found response when like not found" do
        delete like_path(0), headers: request_login
        expect(response).to be_not_found
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET api/v1/reviews/:review_id/likes" do
      it "returns an unauthorized response" do
        like = Like.create! valid_attributes
        get review_likes_path(like.review.id), headers: nil

        expect_unauthorized
      end
    end

    describe "GET api/v1/likes/:id" do
      it "returns an unauthorized response" do
        like = Like.create! valid_attributes
        get like_path(like.id), headers: nil

        expect_unauthorized
      end
    end

    describe "POST api/v1/reviews/:review_id/likes" do
      it "does not create a new Like" do
        review = create(:product_review)

        expect do
          post review_likes_path(review.id), params: { like: valid_attributes }, headers: nil
        end.to change(Like, :count).by(0)
      end

      it "returns an unauthorized response" do
        review = create(:product_review)

        post review_likes_path(review.id), params: { like: valid_attributes }, headers: nil
        expect_unauthorized
      end
    end

    describe "DELETE api/v1/likes/:id" do
      it "does not destroy the requested like" do
        like = Like.create! valid_attributes
        expect do
          delete like_path(like.id), headers: nil
        end.to change(Like, :count).by(0)
      end

      it "does not set discarded_at datetime" do
        like = Like.create! valid_attributes
        delete like_path(like.id), headers: nil
        like.reload
        expect(like.discarded?).to be false
      end

      it "returns an unauthorized response" do
        like = Like.create! valid_attributes

        delete like_path(like.id), headers: nil
        expect_unauthorized
      end
    end
  end
end
