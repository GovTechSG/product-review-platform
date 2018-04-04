require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe LikesController, type: :controller do
  let(:valid_attributes) do
    build(:product_review_like).attributes
  end

  let(:create_update_product_like) do
    value = build(:product_review_like).attributes
    value["from_id"] = value["liker_id"]
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

  let(:token) { double acceptable?: true }

  before(:each, authorized: true) do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  describe "Authorised user" do
    describe "GET #index" do
      it "returns a success response", authorized: true do
        like = Like.create! valid_attributes
        get :index, params: { review_id: like.likeable.id }

        expect(response).to be_success
      end

      it "returns 25 result (1 page)", authorized: true do
        default_result_per_page = 25
        num_of_object_to_create = 30
        review = Review.create! build(:service_review).attributes

        while num_of_object_to_create > 0
          Like.create! build(:product_review_like, likeable: review).attributes
          num_of_object_to_create -= 1
        end

        get :index, params: { review_id: review.id }
        expect(JSON.parse(response.body).count).to match default_result_per_page
      end

      it "returns not found if likeable is deleted", authorized: true do
        like = Like.create! valid_attributes
        like.likeable.discard
        get :index, params: { review_id: like.likeable.id }

        expect(response).to be_not_found
      end

      it "returns not found if reviewable is deleted", authorized: true do
        like = Like.create! valid_attributes
        like.likeable.reviewable.discard
        get :index, params: { review_id: like.likeable.id }

        expect(response).to be_not_found
      end

      it "returns not found if company is deleted", authorized: true do
        like = Like.create! valid_attributes
        like.likeable.reviewable.company.discard
        get :index, params: { review_id: like.likeable.id }

        expect(response).to be_not_found
      end

      it "does not return deleted likes", authorized: true do
        like = Like.create! valid_attributes
        like.discard
        get :index, params: { review_id: like.likeable.id }

        expect(response).to be_success
        expect(parsed_response).to match([])
      end
    end

    describe "GET #show" do
      it "returns a success response", authorized: true do
        like = Like.create! valid_attributes
        get :show, params: { id: like.to_param }
        expect(response).to be_success
      end

      it "returns not found when like not found", authorized: true do
        get :show, params: { id: 0 }
        expect(response).to be_not_found
      end

      it "returns not found when like is deleted", authorized: true do
        like = Like.create! valid_attributes
        like.discard
        get :show, params: { id: like.to_param }
        expect(response).to be_not_found
      end

      it "returns not found when review is deleted", authorized: true do
        like = Like.create! valid_attributes
        like.likeable.discard
        get :show, params: { id: like.to_param }
        expect(response).to be_not_found
      end

      it "returns not found when reviewable is deleted", authorized: true do
        like = Like.create! valid_attributes
        like.likeable.reviewable.discard
        get :show, params: { id: like.to_param }
        expect(response).to be_not_found
      end

      it "returns not found when company is deleted", authorized: true do
        like = Like.create! valid_attributes
        like.likeable.reviewable.company.discard
        get :show, params: { id: like.to_param }
        expect(response).to be_not_found
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Like", authorized: true do
          review = create(:product_review)

          expect do
            post :create, params: { like: create_update_product_like, review_id: review.id }
          end.to change(Like, :count).by(1)
        end

        it "renders a JSON response with the new like", authorized: true do
          review = create(:product_review)

          post :create, params: { like: create_update_product_like, review_id: review.id }
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
            post :create, params: { like: valid_attributes, review_id: review.id }
          end.to change(Like, :count).by(0)
        end

        it "renders not found response", authorized: true do
          review = create(:product_review)
          review.discard

          post :create, params: { like: valid_attributes, review_id: review.id }
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted reviewable" do
        it "does not create Like", authorized: true do
          review = create(:product_review)
          review.reviewable.discard

          expect do
            post :create, params: { like: valid_attributes, review_id: review.id }
          end.to change(Like, :count).by(0)
        end

        it "renders not found response", authorized: true do
          review = create(:product_review)
          review.reviewable.discard

          post :create, params: { like: valid_attributes, review_id: review.id }
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted company" do
        it "does not create Like", authorized: true do
          review = create(:product_review)
          review.reviewable.company.discard

          expect do
            post :create, params: { like: valid_attributes, review_id: review.id }
          end.to change(Like, :count).by(0)
        end

        it "renders not found response", authorized: true do
          review = create(:product_review)
          review.reviewable.company.discard

          post :create, params: { like: valid_attributes, review_id: review.id }
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params", authorized: true do
        it "renders 422 if agency likes twice" do
          like = create(:product_review_like)
          duplicate_like = create_update_product_like
          duplicate_like["from_id"] = like.liker_id

          post :create, params: { like: duplicate_like, review_id: like.likeable_id }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "renders 404 if liker doesnt exist" do
          review = create(:product_review)

          post :create, params: { like: invalid_attributes, review_id: review.id }
          expect(response).to be_not_found
          expect(response.content_type).to eq('application/json')
        end

        it "return 422 when from type is not subclass of liker", authorized: true do
          review = create(:product_review)
          create_update_product_like["from_type"] = "string"

          post :create, params: { like: create_update_product_like, review_id: review.id }
          expect(response).to have_http_status(422)
          expect(response.content_type).to eq('application/json')
        end

        it "does not creates a new Like when liker is deleted", authorized: true do
          review = create(:product_review)
          agency = Agency.create! build(:agency).attributes
          create_update_product_like["from_id"] = agency.id
          agency.discard
          expect do
            post :create, params: { like: create_update_product_like, review_id: review.id }
          end.to change(Review, :count).by(0)
        end
      end
    end

    describe "DELETE #destroy" do
      it "soft deletes", authorized: true do
        like = Like.create! valid_attributes
        expect do
          delete :destroy, params: { id: like.to_param }, session: valid_session
        end.to change(Like, :count).by(0)
      end

      it "sets discarded_at datetime", authorized: true do
        like = Like.create! valid_attributes
        delete :destroy, params: { id: like.to_param }
        like.reload
        expect(like.discarded?).to be true
      end

      it "renders a JSON response with the like", authorized: true do
        like = Like.create! valid_attributes

        delete :destroy, params: { id: like.to_param }
        expect(response).to have_http_status(204)
      end

      it "returns a not found response when like not found", authorized: true do
        delete :destroy, params: { id: 0 }
        expect(response).to be_not_found
      end

      it "returns a not found response when like is deleted", authorized: true do
        like = Like.create! valid_attributes
        like.discard
        delete :destroy, params: { id: like.to_param }
        expect(response).to have_http_status(404)
      end

      it "returns a not found response when review is deleted", authorized: true do
        like = Like.create! valid_attributes
        like.likeable.discard
        delete :destroy, params: { id: like.to_param }
        expect(response).to have_http_status(404)
      end

      it "returns a not found response when reviewable is deleted", authorized: true do
        like = Like.create! valid_attributes
        like.likeable.reviewable.discard
        delete :destroy, params: { id: like.to_param }
        expect(response).to have_http_status(404)
      end

      it "returns a not found response when company is deleted", authorized: true do
        like = Like.create! valid_attributes
        like.likeable.reviewable.company.discard
        delete :destroy, params: { id: like.to_param }
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET #index" do
      it "returns an unauthorized response", authorized: false do
        like = Like.create! valid_attributes
        get :index, params: { review_id: like.likeable.id }

        expect_unauthorized
      end
    end

    describe "GET #show" do
      it "returns an unauthorized response", authorized: false do
        like = Like.create! valid_attributes
        get :show, params: { id: like.to_param }

        expect_unauthorized
      end
    end

    describe "POST #create" do
      it "does not create a new Like", authorized: false do
        review = create(:product_review)

        expect do
          post :create, params: { like: valid_attributes, review_id: review.id }
        end.to change(Like, :count).by(0)
      end

      it "returns an unauthorized response", authorized: false do
        review = create(:product_review)

        post :create, params: { like: valid_attributes, review_id: review.id }
        expect_unauthorized
      end
    end

    describe "DELETE #destroy" do
      it "does not destroy the requested like", authorized: false do
        like = Like.create! valid_attributes
        expect do
          delete :destroy, params: { id: like.to_param }, session: valid_session
        end.to change(Like, :count).by(0)
      end

      it "does not set discarded_at datetime", authorized: false do
        like = Like.create! valid_attributes
        delete :destroy, params: { id: like.to_param }
        like.reload
        expect(like.discarded?).to be false
      end

      it "returns an unauthorized response", authorized: false do
        like = Like.create! valid_attributes

        delete :destroy, params: { id: like.to_param }, session: valid_session
        expect_unauthorized
      end
    end
  end
end
