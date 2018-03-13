require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Likes", type: :request do
  let(:valid_attributes) do
    build(:product_review_like).attributes
  end

  let(:invalid_attributes) do
    build(:product_review_like, review_id: nil, agency_id: nil).attributes
  end

  let(:valid_session) {}

  describe "Authorised user" do
    describe "GET api/v1/reviews/:review_id/likes" do
      it "returns a success response" do
        like = Like.create! valid_attributes
        get review_likes_path(like.review.id), headers: request_login

        expect(response).to be_success
      end

      it "returns not found if review is deleted", authorized: true do
        like = Like.create! valid_attributes
        like.review.discard
        get review_likes_path(like.review.id), headers: request_login

        expect(response).to be_not_found
      end

      it "returns not found if reviewable is deleted", authorized: true do
        like = Like.create! valid_attributes
        like.review.reviewable.discard
        get review_likes_path(like.review.id), headers: request_login

        expect(response).to be_not_found
      end

      it "returns not found if company is deleted", authorized: true do
        like = Like.create! valid_attributes
        like.review.reviewable.company.discard
        get review_likes_path(like.review.id), headers: request_login

        expect(response).to be_not_found
      end

      it "does not return deleted likes", authorized: true do
        like = Like.create! valid_attributes
        like.discard
        get review_likes_path(like.review.id), headers: request_login

        expect(response).to be_success
        expect(parsed_response).to match([])
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

      it "returns not found when like is deleted", authorized: true do
        like = Like.create! valid_attributes
        like.discard
        get like_path(like.id), headers: request_login
        expect(response).to be_not_found
      end

      it "returns not found when review is deleted", authorized: true do
        like = Like.create! valid_attributes
        like.review.discard
        get like_path(like.id), headers: request_login
        expect(response).to be_not_found
      end

      it "returns not found when reviewable is deleted", authorized: true do
        like = Like.create! valid_attributes
        like.review.reviewable.discard
        get like_path(like.id), headers: request_login
        expect(response).to be_not_found
      end

      it "returns not found when company is deleted", authorized: true do
        like = Like.create! valid_attributes
        like.review.reviewable.company.discard
        get like_path(like.id), headers: request_login
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

      context "with deleted review" do
        it "does not create Like", authorized: true do
          review = create(:product_review)
          review.discard

          expect do
            post review_likes_path(review.id), params: { like: valid_attributes }, headers: request_login
          end.to change(Like, :count).by(0)
        end

        it "renders not found response", authorized: true do
          review = create(:product_review)
          review.discard

          post review_likes_path(review.id), params: { like: valid_attributes }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted reviewable" do
        it "does not create Like", authorized: true do
          review = create(:product_review)
          review.reviewable.discard

          expect do
            post review_likes_path(review.id), params: { like: valid_attributes }, headers: request_login
          end.to change(Like, :count).by(0)
        end

        it "renders not found response", authorized: true do
          review = create(:product_review)
          review.reviewable.discard

          post review_likes_path(review.id), params: { like: valid_attributes }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted company" do
        it "does not create Like", authorized: true do
          review = create(:product_review)
          review.reviewable.company.discard

          expect do
            post review_likes_path(review.id), params: { like: valid_attributes }, headers: request_login
          end.to change(Like, :count).by(0)
        end

        it "renders not found response", authorized: true do
          review = create(:product_review)
          review.reviewable.company.discard

          post review_likes_path(review.id), params: { like: valid_attributes }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params" do
        it "renders 422 if agency likes twice" do
          like = create(:product_review_like)
          duplicate_like = attributes_for(:product_review_like, agency_id: like.agency_id)
          post review_likes_path(like.review_id), params: { like: duplicate_like }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "renders 404 if agency doesnt exist" do
          review = create(:product_review)
          post review_likes_path(review.id), params: { like: invalid_attributes }, headers: request_login
          expect(response).to be_not_found
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

      it "returns a not found response when like is deleted", authorized: true do
        like = Like.create! valid_attributes
        like.discard
        delete like_path(like.id), headers: request_login
        expect(response).to have_http_status(404)
      end

      it "returns a not found response when review is deleted", authorized: true do
        like = Like.create! valid_attributes
        like.review.discard
        delete like_path(like.id), headers: request_login
        expect(response).to have_http_status(404)
      end

      it "returns a not found response when reviewable is deleted", authorized: true do
        like = Like.create! valid_attributes
        like.review.reviewable.discard
        delete like_path(like.id), headers: request_login
        expect(response).to have_http_status(404)
      end

      it "returns a not found response when company is deleted", authorized: true do
        like = Like.create! valid_attributes
        like.review.reviewable.company.discard
        delete like_path(like.id), headers: request_login
        expect(response).to have_http_status(404)
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
