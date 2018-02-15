require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe LikesController, type: :controller do
  let(:valid_attributes) do
    build(:product_review_like).attributes
  end

  let(:invalid_attributes) do
    build(:product_review_like, review_id: nil, agency_id: nil).attributes
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
        get :index, params: { review_id: like.review.id }

        expect(response).to be_success
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
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Like", authorized: true do
          review = create(:product_review)

          expect do
            post :create, params: { like: valid_attributes, review_id: review.id }
          end.to change(Like, :count).by(1)
        end

        it "renders a JSON response with the new like", authorized: true do
          review = create(:product_review)

          post :create, params: { like: valid_attributes, review_id: review.id }
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(like_url(Like.last))
        end
      end

      context "with invalid params", authorized: true do
        it "renders a JSON response with errors for the new like" do
          review = create(:product_review)
          post :create, params: { like: invalid_attributes, review_id: review.id }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
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
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end

      it "returns a not found response when like not found", authorized: true do
        delete :destroy, params: { id: 0 }
        expect(response).to be_not_found
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET #index" do
      it "returns an unauthorized response", authorized: false do
        like = Like.create! valid_attributes
        get :index, params: { review_id: like.review.id }

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
