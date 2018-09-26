require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Likes", type: :request do
  let(:valid_attributes) do
    build(:product_review_like).attributes
  end

  let(:create_update_product_like) do
    value = build(:product_review_like).attributes
    value["from_id"] = Agency.find(value["liker_id"]).hashid
    value["from_type"] = value["liker_type"]
    value.delete("liker_id")
    value.delete("liker_type")
    value
  end

  let(:invalid_attributes) do
    value = build(:product_review_like, likeable_id: 0, liker_id: 0, liker_type: "agency").attributes
    value["from_id"] = value["liker_id"]
    value["from_type"] = value["liker_type"]
    value.delete("liker_id")
    value.delete("liker_type")
    value
  end

  let(:valid_session) {}

  before(:each) do
    @company_reviewable = create(:company_product)
    @product = @company_reviewable.reviewable
    @company = @company_reviewable.company
    @review = @product.reviews.create!(build(:product_review, vendor_id: @company.id).attributes)
    @agency = create(:agency)
    @like = @review.likes.create!(liker: @agency, likeable: @product)
  end

  describe "Authorised user" do
    describe "GET api/v1/reviews/:review_id/likes" do
      it "returns a success response" do
        get review_likes_path(@review.hashid), headers: request_login

        expect(response).to be_success
      end

      it "returns not found if review is deleted", authorized: true do
        @review.discard
        get review_likes_path(@review.hashid), headers: request_login

        expect(response).to be_not_found
      end

      it "returns not found if reviewable is deleted", authorized: true do
        @product.discard
        get review_likes_path(@product.hashid), headers: request_login

        expect(response).to be_not_found
      end

      it "returns not found if company is deleted", authorized: true do
        @company.discard
        get review_likes_path(@review.hashid), headers: request_login

        expect(response).to be_not_found
      end

      it "does not return deleted likes", authorized: true do
        @like.discard
        get review_likes_path(@like.likeable.hashid), headers: request_login

        expect(response).to be_success
        expect(parsed_response).to match([])
      end
    end

    describe "GET api/v1/likes/:id" do
      it "returns a success response" do
        get like_path(@like.hashid), headers: request_login
        expect(response).to be_success
      end

      it "returns not found when like not found" do
        get like_path(0), headers: request_login
        expect(response).to be_not_found
      end

      it "returns not found when like is deleted", authorized: true do
        @like.discard
        get like_path(@like.hashid), headers: request_login
        expect(response).to be_not_found
      end

      it "returns not found when review is deleted", authorized: true do
        @like.likeable.discard
        get like_path(@like.hashid), headers: request_login
        expect(response).to be_not_found
      end

      it "returns not found when reviewable is deleted", authorized: true do
        @product.discard
        get like_path(@like.hashid), headers: request_login
        expect(response).to be_not_found
      end

      it "returns not found when company is deleted", authorized: true do
        @company.discard
        get like_path(@like.hashid), headers: request_login
        expect(response).to be_not_found
      end
    end

    describe "POST api/v1/reviews/:review_id/likes" do
      context "with valid params" do
        it "creates a new Like" do
          expect do
            post review_likes_path(@review.hashid), params: { like: create_update_product_like }, headers: request_login
          end.to change(Like, :count).by(1)
        end

        it "renders a JSON response with the new like" do
          post review_likes_path(@review.hashid), params: { like: create_update_product_like }, headers: request_login
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(like_url(Like.last))
        end
      end

      context "with deleted review" do
        it "does not create Like", authorized: true do
          @review.discard

          expect do
            post review_likes_path(@review.hashid), params: { like: create_update_product_like }, headers: request_login
          end.to change(Like, :count).by(0)
        end

        it "renders not found response", authorized: true do
          @review.discard

          post review_likes_path(@review.id), params: { like: valid_attributes }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted reviewable" do
        it "does not create Like", authorized: true do
          @product.discard

          expect do
            post review_likes_path(@review.hashid), params: { like: valid_attributes }, headers: request_login
          end.to change(Like, :count).by(0)
        end

        it "renders not found response", authorized: true do
          @product.discard

          post review_likes_path(@review.hashid), params: { like: valid_attributes }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted company" do
        it "does not create Like", authorized: true do
          @company.discard

          expect do
            post review_likes_path(@review.hashid), params: { like: valid_attributes }, headers: request_login
          end.to change(Like, :count).by(0)
        end

        it "renders not found response", authorized: true do
          @company.discard

          post review_likes_path(@review.id), params: { like: valid_attributes }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params" do
        it "renders 422 if agency likes twice" do
          duplicate_like = create_update_product_like
          duplicate_like["from_id"] = @like.liker.hashid

          post review_likes_path(@like.likeable.hashid), params: { like: duplicate_like }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "renders 404 if agency doesnt exist" do
          post review_likes_path(@review.hashid), params: { like: invalid_attributes }, headers: request_login
          expect(response).to be_not_found
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "DELETE api/v1/likes/:id" do
      it "soft deletes" do
        expect do
          delete like_path(@like.hashid), headers: request_login
        end.to change(Like, :count).by(0)
      end

      it "sets discarded_at datetime" do
        delete like_path(@like.hashid), headers: request_login
        @like.reload
        expect(@like.discarded?).to be true
      end

      it "renders a JSON response with the like" do
        delete like_path(@like.hashid), headers: request_login
        expect(response).to have_http_status(204)
      end

      it "returns a not found response when like not found" do
        delete like_path(0), headers: request_login
        expect(response).to be_not_found
      end

      it "returns a not found response when like is deleted", authorized: true do
        @like.discard
        delete like_path(@like.hashid), headers: request_login
        expect(response).to have_http_status(404)
      end

      it "returns a not found response when review is deleted", authorized: true do
        @review.discard
        delete like_path(@like.hashid), headers: request_login
        expect(response).to have_http_status(404)
      end

      it "returns a not found response when reviewable is deleted", authorized: true do
        @product.discard
        delete like_path(@like.hashid), headers: request_login
        expect(response).to have_http_status(404)
      end

      it "returns a not found response when company is deleted", authorized: true do
        @company.discard
        delete like_path(@like.hashid), headers: request_login
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET api/v1/reviews/:review_id/likes" do
      it "returns an unauthorized response" do
        get review_likes_path(@review.hashid), headers: nil

        expect_unauthorized
      end
    end

    describe "GET api/v1/likes/:id" do
      it "returns an unauthorized response" do
        like = Like.create! valid_attributes
        get like_path(@like.hashid), headers: nil

        expect_unauthorized
      end
    end

    describe "POST api/v1/reviews/:review_id/likes" do
      it "does not create a new Like" do
        expect do
          post review_likes_path(@review.hashid), params: { like: valid_attributes }, headers: nil
        end.to change(Like, :count).by(0)
      end

      it "returns an unauthorized response" do
        post review_likes_path(@review.hashid), params: { like: valid_attributes }, headers: nil
        expect_unauthorized
      end
    end

    describe "DELETE api/v1/likes/:id" do
      it "does not destroy the requested like" do
        expect do
          delete like_path(@like.hashid), headers: nil
        end.to change(Like, :count).by(0)
      end

      it "does not set discarded_at datetime" do
        delete like_path(@like.hashid), headers: nil
        @like.reload
        expect(@like.discarded?).to be false
      end

      it "returns an unauthorized response" do
        delete like_path(@like.id), headers: nil
        expect_unauthorized
      end
    end
  end
end
