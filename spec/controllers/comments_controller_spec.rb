require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe CommentsController, type: :controller do
  let(:product_comment_valid_attributes) do
    build(:product_review_comment).attributes
  end

  let(:service_comment_valid_attributes) do
    build(:service_review_comment).attributes
  end

  let(:product_comment_invalid_attributes) do
    build(:product_review_comment, content: nil).attributes
  end

  let(:service_comment_invalid_attributes) do
    build(:service_review_comment, content: nil).attributes
  end

  let(:product_comment_missing_userid_attributes) do
    build(:product_review_comment, user_id: 0).attributes
  end

  let(:service_comment_missing_userid_attributes) do
    build(:service_review_comment, user_id: 0).attributes
  end

  let(:valid_session) {}

  let(:token) { double acceptable?: true }

  before(:each, authorized: true) do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  describe "Authorised user" do
    describe "GET #index" do
      it "returns a success response from a product comment", authorized: true do
        comment = Comment.create! product_comment_valid_attributes
        get :index, params: { review_id: comment.review.id }

        expect(response).to be_success
      end

      it "returns a success response from a service comment", authorized: true do
        comment = Comment.create! service_comment_valid_attributes
        get :index, params: { review_id: comment.review.id }

        expect(response).to be_success
      end

      it "returns not found when review not found", authorized: true do
        get :index, params: { review_id: 0 }
        expect(response).to be_not_found
      end

      it "returns a not found response when the review is deleted", authorized: true do
        review = Review.create! valid_product_review
        review.reviewable.discard
        get :index, params: { product_id: review.reviewable_id }

        expect(response).to be_not_found
      end
    end

    describe "GET #show" do
      it "returns a success response from a product comment", authorized: true do
        comment = Comment.create! product_comment_valid_attributes
        get :show, params: { id: comment.to_param }
        expect(response).to be_success
      end

      it "returns a success response from a service comment", authorized: true do
        comment = Comment.create! service_comment_valid_attributes
        get :show, params: { id: comment.to_param }
        expect(response).to be_success
      end

      it "returns not found when comment not found", authorized: true do
        get :show, params: { id: 0 }
        expect(response).to be_not_found
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Comment to product", authorized: true do
          review = create(:product_review)

          expect do
            post :create, params: { comment: product_comment_valid_attributes, review_id: review.id }
          end.to change(Comment, :count).by(1)
        end

        it "creates a new Comment to service", authorized: true do
          review = create(:service_review)

          expect do
            post :create, params: { comment: service_comment_valid_attributes, review_id: review.id }
          end.to change(Comment, :count).by(1)
        end

        it "renders a JSON response with the new comment to product", authorized: true do
          review = create(:product_review)

          post :create, params: { comment: product_comment_valid_attributes, review_id: review.id }
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(comment_url(Comment.last))
        end

        it "renders a JSON response with the new comment to service", authorized: true do
          review = create(:service_review)

          post :create, params: { comment: service_comment_valid_attributes, review_id: review.id }
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(comment_url(Comment.last))
        end

        it "returns not found when product_review_id not found", authorized: true do
          post :create, params: { comment: product_comment_valid_attributes, review_id: 0 }
          expect(response).to be_not_found
        end

        it "returns not found when service_review_id not found", authorized: true do
          post :create, params: { comment: service_comment_valid_attributes, review_id: 0 }
          expect(response).to be_not_found
        end

        it "returns not found when product_user_id not found", authorized: true do
          review = create(:product_review)

          post :create, params: { comment: product_comment_missing_userid_attributes, review_id: review.id }
          expect(response).to be_not_found
        end

        it "returns not found when service_user_id not found", authorized: true do
          review = create(:service_review)

          post :create, params: { comment: service_comment_missing_userid_attributes, review_id: review.id }
          expect(response).to be_not_found
        end
      end

      context "with invalid params", authorized: true do
        it "renders a JSON response with errors for the new comment on product" do
          review = create(:product_review)

          post :create, params: { comment: product_comment_invalid_attributes, review_id: review.id }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "renders a JSON response with errors for the new comment on service" do
          review = create(:service_review)

          post :create, params: { comment: service_comment_invalid_attributes, review_id: review.id }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:product_comment_new_attributes) do
          attributes_for(:product_review_comment)
        end

        let(:service_comment_new_attributes) do
          attributes_for(:service_review_comment)
        end

        it "updates the requested product_comment", authorized: true do
          comment = Comment.create! product_comment_valid_attributes

          put :update, params: { id: comment.to_param, comment: product_comment_new_attributes }, session: valid_session
          comment.reload
          expect(comment.content).to eq(product_comment_new_attributes[:content])
        end

        it "renders a JSON response with the product_comment", authorized: true do
          comment = Comment.create! product_comment_valid_attributes

          put :update, params: { id: comment.to_param, comment: product_comment_new_attributes }, session: valid_session
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end

        it "updates the requested service_comment", authorized: true do
          comment = Comment.create! service_comment_valid_attributes

          put :update, params: { id: comment.to_param, comment: service_comment_new_attributes }, session: valid_session
          comment.reload
          expect(comment.content).to eq(service_comment_new_attributes[:content])
        end

        it "renders a JSON response with the service_comment", authorized: true do
          comment = Comment.create! service_comment_valid_attributes

          put :update, params: { id: comment.to_param, comment: service_comment_new_attributes }, session: valid_session
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end

        it "returns not found when comment ID not found", authorized: true do
          put :update, params: { id: 0, comment: service_comment_new_attributes }, session: valid_session
          expect(response).to be_not_found
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the product_comment", authorized: true do
          comment = Comment.create! product_comment_valid_attributes

          put :update, params: { id: comment.to_param, comment: product_comment_invalid_attributes }, session: valid_session
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "renders a JSON response with errors for the service_comment", authorized: true do
          comment = Comment.create! service_comment_valid_attributes

          put :update, params: { id: comment.to_param, comment: service_comment_invalid_attributes }, session: valid_session
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "DELETE #destroy" do
      it "soft deletes product_comment", authorized: true do
        comment = Comment.create! product_comment_valid_attributes
        expect do
          delete :destroy, params: { id: comment.to_param }, session: valid_session
        end.to change(Comment, :count).by(0)
      end

      it "soft deletes service_comment", authorized: true do
        comment = Comment.create! service_comment_valid_attributes
        expect do
          delete :destroy, params: { id: comment.to_param }, session: valid_session
        end.to change(Comment, :count).by(0)
      end

      it "sets discarded_at datetime for product_comment", authorized: true do
        comment = Comment.create! product_comment_valid_attributes
        delete :destroy, params: { id: comment.to_param }
        comment.reload
        expect(comment.discarded?).to be true
      end

      it "sets discarded_at datetime for service_comment", authorized: true do
        comment = Comment.create! service_comment_valid_attributes
        delete :destroy, params: { id: comment.to_param }
        comment.reload
        expect(comment.discarded?).to be true
      end

      it "renders a JSON response with the product_comment", authorized: true do
        comment = Comment.create! product_comment_valid_attributes

        delete :destroy, params: { id: comment.to_param }
        expect(response).to have_http_status(204)
      end

      it "renders a JSON response with the service_comment", authorized: true do
        comment = Comment.create! service_comment_valid_attributes

        delete :destroy, params: { id: comment.to_param }
        expect(response).to have_http_status(204)
      end

      it "returns a not found response when comment not found", authorized: true do
        delete :destroy, params: { id: 0 }
        expect(response).to be_not_found
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET #index" do
      it "returns an unauthorized response from product_comment", authorized: false do
        comment = Comment.create! product_comment_valid_attributes
        get :index, params: { review_id: comment.review.id }

        expect_unauthorized
      end

      it "returns an unauthorized response from service_comment", authorized: false do
        comment = Comment.create! service_comment_valid_attributes
        get :index, params: { review_id: comment.review.id }

        expect_unauthorized
      end
    end

    describe "GET #show" do
      it "returns an unauthorized response from product_comment", authorized: false do
        comment = Comment.create! product_comment_valid_attributes
        get :show, params: { id: comment.to_param }

        expect_unauthorized
      end

      it "returns an unauthorized response from service_comment", authorized: false do
        comment = Comment.create! service_comment_valid_attributes
        get :show, params: { id: comment.to_param }

        expect_unauthorized
      end
    end

    describe "POST #create" do
      it "does not create a new product_comment", authorized: false do
        review = create(:product_review)

        expect do
          post :create, params: { comment: product_comment_valid_attributes, review_id: review.id }
        end.to change(Comment, :count).by(0)
      end

      it "returns an unauthorized response from product_comment", authorized: false do
        review = create(:product_review)

        post :create, params: { comment: product_comment_valid_attributes, review_id: review.id }
        expect_unauthorized
      end

      it "does not create a new service_comment", authorized: false do
        review = create(:service_review)

        expect do
          post :create, params: { comment: service_comment_valid_attributes, review_id: review.id }
        end.to change(Comment, :count).by(0)
      end

      it "returns an unauthorized response from service_comment", authorized: false do
        review = create(:service_review)

        post :create, params: { comment: service_comment_valid_attributes, review_id: review.id }
        expect_unauthorized
      end
    end

    describe "PUT #update" do
      let(:product_comment_new_attributes) do
        attributes_for(:product_review_comment)
      end

      let(:service_comment_new_attributes) do
        attributes_for(:service_review_comment)
      end

      it "does not update the requested product_comment", authorized: false do
        comment = Comment.create! product_comment_valid_attributes
        current_attributes = comment.attributes

        put :update, params: { id: comment.to_param, comment: product_comment_new_attributes }, session: valid_session
        comment.reload
        expect(comment.content).to eq(current_attributes["content"])
      end

      it "returns an unauthorized response for product_comment", authorized: false do
        comment = Comment.create! product_comment_valid_attributes

        put :update, params: { id: comment.to_param, comment: product_comment_valid_attributes }, session: valid_session
        expect_unauthorized
      end

      it "does not update the requested service_comment", authorized: false do
        comment = Comment.create! service_comment_valid_attributes
        current_attributes = comment.attributes

        put :update, params: { id: comment.to_param, comment: service_comment_new_attributes }, session: valid_session
        comment.reload
        expect(comment.content).to eq(current_attributes["content"])
      end

      it "returns an unauthorized response for service_comment", authorized: false do
        comment = Comment.create! service_comment_valid_attributes

        put :update, params: { id: comment.to_param, comment: service_comment_valid_attributes }, session: valid_session
        expect_unauthorized
      end
    end

    describe "DELETE #destroy" do
      it "does not destroy the requested product_comment", authorized: false do
        comment = Comment.create! product_comment_valid_attributes
        expect do
          delete :destroy, params: { id: comment.to_param }, session: valid_session
        end.to change(Comment, :count).by(0)
      end

      it "does not set discarded_at datetime for product_comment", authorized: false do
        comment = Comment.create! product_comment_valid_attributes
        delete :destroy, params: { id: comment.to_param }
        comment.reload
        expect(comment.discarded?).to be false
      end

      it "returns an unauthorized response for product_comment", authorized: false do
        comment = Comment.create! product_comment_valid_attributes

        delete :destroy, params: { id: comment.to_param }, session: valid_session
        expect_unauthorized
      end

      it "does not destroy the requested service_comment", authorized: false do
        comment = Comment.create! service_comment_valid_attributes
        expect do
          delete :destroy, params: { id: comment.to_param }, session: valid_session
        end.to change(Comment, :count).by(0)
      end

      it "does not set discarded_at datetime for service_comment", authorized: false do
        comment = Comment.create! service_comment_valid_attributes
        delete :destroy, params: { id: comment.to_param }
        comment.reload
        expect(comment.discarded?).to be false
      end

      it "returns an unauthorized response for service_comment", authorized: false do
        comment = Comment.create! service_comment_valid_attributes

        delete :destroy, params: { id: comment.to_param }, session: valid_session
        expect_unauthorized
      end
    end
  end
end
