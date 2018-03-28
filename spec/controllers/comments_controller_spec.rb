require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe CommentsController, type: :controller do
  let(:product_comment_valid_attributes) do
    build(:product_review_comment).attributes
  end

  let(:create_update_product_comment) do
    value = build(:product_review_comment).attributes
    value["from_id"] = value["commenter_id"]
    value["from_type"] = value["commenter_type"]
    value.delete("commenter_id")
    value.delete("commenter_type")
    value
  end

  let(:service_comment_valid_attributes) do
    build(:service_review_comment).attributes
  end

  let(:create_update_service_comment) do
    value = build(:service_review_comment).attributes
    value["from_id"] = value["commenter_id"]
    value["from_type"] = value["commenter_type"]
    value.delete("commenter_id")
    value.delete("commenter_type")
    value
  end

  let(:product_comment_invalid_attributes) do
    value = build(:product_review_comment, content: nil).attributes
    value["from_id"] = value["commenter_id"]
    value["from_type"] = value["commenter_type"]
    value.delete("commenter_id")
    value.delete("commenter_type")
    value
  end

  let(:service_comment_invalid_attributes) do
    value = build(:service_review_comment, content: nil).attributes
    value["from_id"] = value["commenter_id"]
    value["from_type"] = value["commenter_type"]
    value.delete("commenter_id")
    value.delete("commenter_type")
    value
  end

  let(:product_comment_missing_agencyid_attributes) do
    value = build(:product_review_comment, commenter_id: 0, commenter_type: "Agency").attributes
    value["from_id"] = value["commenter_id"]
    value["from_type"] = value["commenter_type"]
    value.delete("commenter_id")
    value.delete("commenter_type")
    value
  end

  let(:service_comment_missing_agencyid_attributes) do
    build(:service_review_comment, agency_id: 0).attributes
  end

  let(:valid_session) {}

  let(:token) { double acceptable?: true }

  before(:each, authorized: true) do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  describe "Authorised agency" do
    describe "GET #index" do
      it "returns a success response from a product comment", authorized: true do
        comment = Comment.create! product_comment_valid_attributes
        get :index, params: { review_id: comment.commentable.id }
        expect(response).to be_success
      end

      it "returns a success response from a service comment", authorized: true do
        comment = Comment.create! service_comment_valid_attributes
        get :index, params: { review_id: comment.commentable.id }

        expect(response).to be_success
      end

      it "does not return deleted comments", authorized: true do
        comment = Comment.create! product_comment_valid_attributes
        comment.discard
        get :index, params: { review_id: comment.commentable.id }

        expect(parsed_response).to match([])
        expect(response).to be_success
      end

      it "returns not found when review not found", authorized: true do
        get :index, params: { review_id: 0 }
        expect(response).to be_not_found
      end

      it "returns a not found response when the review is deleted", authorized: true do
        comment = Comment.create! product_comment_valid_attributes
        comment.commentable.discard
        get :index, params: { review_id: comment.commentable.id }

        expect(response).to be_not_found
      end

      it "returns a not found response when the reviewable is deleted", authorized: true do
        comment = Comment.create! product_comment_valid_attributes
        comment.commentable.reviewable.discard
        get :index, params: { review_id: comment.commentable.id }
        expect(response).to be_not_found
      end

      it "returns a not found response when the company is deleted", authorized: true do
        comment = Comment.create! product_comment_valid_attributes
        comment.commentable.reviewable.company.discard
        get :index, params: { review_id: comment.commentable.id }
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

      it "returns not found when comment is deleted", authorized: true do
        comment = Comment.create! product_comment_valid_attributes
        comment.discard
        get :show, params: { id: comment.to_param }
        expect(response).to be_not_found
      end

      it "returns a not found response when the review is deleted", authorized: true do
        comment = Comment.create! product_comment_valid_attributes
        comment.commentable.discard
        get :show, params: { id: comment.to_param }

        expect(response).to be_not_found
      end

      it "returns a not found response when the reviewable is deleted", authorized: true do
        comment = Comment.create! product_comment_valid_attributes
        comment.commentable.reviewable.discard
        get :show, params: { id: comment.to_param }
        expect(response).to be_not_found
      end

      it "returns a not found response when the company is deleted", authorized: true do
        comment = Comment.create! product_comment_valid_attributes
        comment.commentable.reviewable.company.discard
        get :show, params: { id: comment.id }
        expect(response).to be_not_found
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Comment to product", authorized: true do
          review = create(:product_review)
          expect do
            post :create, params: { comment: create_update_product_comment, review_id: review.id }
          end.to change(Comment, :count).by(1)
        end

        it "creates a new Comment to service", authorized: true do
          review = create(:service_review)

          expect do
            post :create, params: { comment: create_update_service_comment, review_id: review.id }
          end.to change(Comment, :count).by(1)
        end

        it "renders a JSON response with the new comment to product", authorized: true do
          review = create(:product_review)

          post :create, params: { comment: create_update_product_comment, review_id: review.id }
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(comment_url(Comment.last))
        end

        it "renders a JSON response with the new comment to service", authorized: true do
          review = create(:service_review)

          post :create, params: { comment: create_update_service_comment, review_id: review.id }
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

        it "returns not found when commenter_id not found", authorized: true do
          review = create(:product_review)

          post :create, params: { comment: product_comment_missing_agencyid_attributes, review_id: review.id }
          expect(response).to be_not_found
        end

        it "does not create Comment when review is deleted", authorized: true do
          review = create(:product_review)
          review.discard

          expect do
            post :create, params: { comment: product_comment_missing_agencyid_attributes, review_id: review.id }
          end.to change(Comment, :count).by(0)
        end

        it "returns a not found response when the review is deleted", authorized: true do
          review = create(:product_review)
          review.discard
          post :create, params: { comment: product_comment_missing_agencyid_attributes, review_id: review.id }

          expect(response).to be_not_found
          expect(response.content_type).to eq('application/json')
        end

        it "does not create Comment when reviewable is deleted", authorized: true do
          review = create(:product_review)
          review.reviewable.discard

          expect do
            post :create, params: { comment: product_comment_missing_agencyid_attributes, review_id: review.id }
          end.to change(Comment, :count).by(0)
        end

        it "returns a not found response when the reviewable is deleted", authorized: true do
          review = create(:product_review)
          review.reviewable.discard
          post :create, params: { comment: product_comment_missing_agencyid_attributes, review_id: review.id }

          expect(response).to be_not_found
          expect(response.content_type).to eq('application/json')
        end

        it "does not create Comment when company is deleted", authorized: true do
          review = create(:product_review)
          review.reviewable.company.discard

          expect do
            post :create, params: { comment: product_comment_missing_agencyid_attributes, review_id: review.id }
          end.to change(Comment, :count).by(0)
        end

        it "returns a not found response when the company is deleted", authorized: true do
          review = create(:product_review)
          review.reviewable.company.discard
          post :create, params: { comment: product_comment_missing_agencyid_attributes, review_id: review.id }

          expect(response).to be_not_found
          expect(response.content_type).to eq('application/json')
        end

        it "return 422 when from type is not subclass of commenter", authorized: true do
          review = create(:product_review)
          create_update_product_comment["from_type"] = "string"
          post :create, params: { comment: create_update_product_comment, review_id: review.id }
          expect(response).to have_http_status(422)
          expect(response.content_type).to eq('application/json')
        end

        it "does not creates a new Comment when commenter is deleted", authorized: true do
          review = create(:product_review)
          agency = Agency.create! build(:agency).attributes
          create_update_product_comment["from_id"] = agency.id
          agency.discard
          expect do
            post :create, params: { comment: create_update_product_comment, review_id: review.id }
          end.to change(Review, :count).by(0)
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

        it "returns a not found response when agency doesn't exist" do
          review = create(:product_review)

          post :create, params: { comment: product_comment_missing_agencyid_attributes, review_id: review.id }
          expect(response).to be_not_found
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

        it "does not update Comment when review is deleted", authorized: true do
          comment = Comment.create! service_comment_valid_attributes
          original_comment = comment
          comment.commentable.discard

          put :update, params: { id: comment.to_param, comment: service_comment_new_attributes }, session: valid_session
          comment.reload
          expect(comment.content).to eq(original_comment[:content])
        end

        it "returns a not found response when the review is deleted", authorized: true do
          comment = Comment.create! service_comment_valid_attributes
          comment.commentable.discard
          put :update, params: { id: comment.to_param, comment: service_comment_new_attributes }, session: valid_session

          expect(response).to be_not_found
          expect(response.content_type).to eq('application/json')
        end

        it "does not update Comment when reviewable is deleted", authorized: true do
          comment = Comment.create! service_comment_valid_attributes
          original_comment = comment
          comment.commentable.reviewable.discard

          put :update, params: { id: comment.to_param, comment: service_comment_new_attributes }, session: valid_session
          comment.reload
          expect(comment.content).to eq(original_comment[:content])
        end

        it "returns a not found response when the reviewable is deleted", authorized: true do
          comment = Comment.create! service_comment_valid_attributes
          comment.commentable.reviewable.discard
          put :update, params: { id: comment.to_param, comment: service_comment_new_attributes }, session: valid_session

          expect(response).to be_not_found
          expect(response.content_type).to eq('application/json')
        end

        it "does not update Comment when company is deleted", authorized: true do
          comment = Comment.create! service_comment_valid_attributes
          original_comment = comment
          comment.commentable.reviewable.company.discard

          put :update, params: { id: comment.to_param, comment: service_comment_new_attributes }, session: valid_session
          comment.reload
          expect(comment.content).to eq(original_comment[:content])
        end

        it "returns a not found response when the company is deleted", authorized: true do
          comment = Comment.create! service_comment_valid_attributes
          comment.commentable.reviewable.company.discard
          put :update, params: { id: comment.to_param, comment: service_comment_new_attributes }, session: valid_session

          expect(response).to be_not_found
          expect(response.content_type).to eq('application/json')
        end

        it "return 422 when from type is not subclass of commenter", authorized: true do
          comment = Comment.create! service_comment_valid_attributes

          service_comment_new_attributes["from_type"] = "string"
          service_comment_new_attributes["from_id"] = 1
          put :update, params: { id: comment.to_param, comment: service_comment_new_attributes }, session: valid_session
          expect(response).to have_http_status(422)
          expect(response.content_type).to eq('application/json')
        end

        it "does not update the Comment when commenter is deleted", authorized: true do
          comment = Comment.create! service_comment_valid_attributes
          original_comment = comment

          agency = Agency.create! build(:agency).attributes
          service_comment_new_attributes["from_id"] = agency.id
          service_comment_new_attributes["from_type"] = agency.id
          agency.discard

          put :update, params: { id: comment.to_param, comment: service_comment_new_attributes }, session: valid_session
          comment.reload
          expect(comment.content).to eq(original_comment[:content])
        end

        it "return 422 when from type is missing", authorized: true do
          comment = Comment.create! service_comment_valid_attributes
          service_comment_new_attributes["from_id"] = 1
          put :update, params: { id: comment.to_param, comment: service_comment_new_attributes }, session: valid_session
          expect(response).to have_http_status(422)
          expect(response.content_type).to eq('application/json')
        end

        it "return 422 when from id is missing", authorized: true do
          comment = Comment.create! service_comment_valid_attributes
          service_comment_new_attributes["from_type"] = "agency"
          put :update, params: { id: comment.to_param, comment: service_comment_new_attributes }, session: valid_session
          expect(response).to have_http_status(422)
          expect(response.content_type).to eq('application/json')
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

      it "returns a not found response when comment is deleted", authorized: true do
        comment = Comment.create! service_comment_valid_attributes
        comment.discard
        delete :destroy, params: { id: comment.to_param }
        expect(response).to be_not_found
      end

      it "returns a not found response when review is deleted", authorized: true do
        comment = Comment.create! service_comment_valid_attributes
        comment.commentable.discard
        delete :destroy, params: { id: comment.to_param }
        expect(response).to be_not_found
      end

      it "returns a not found response when reviewable is deleted", authorized: true do
        comment = Comment.create! service_comment_valid_attributes
        comment.commentable.reviewable.discard
        delete :destroy, params: { id: comment.to_param }
        expect(response).to be_not_found
      end

      it "returns a not found response when company is deleted", authorized: true do
        comment = Comment.create! service_comment_valid_attributes
        comment.commentable.reviewable.company.discard
        delete :destroy, params: { id: comment.to_param }
        expect(response).to be_not_found
      end
    end
  end

  describe "Unauthorised agency" do
    describe "GET #index" do
      it "returns an unauthorized response from product_comment", authorized: false do
        comment = Comment.create! product_comment_valid_attributes
        get :index, params: { review_id: comment.commentable.id }

        expect_unauthorized
      end

      it "returns an unauthorized response from service_comment", authorized: false do
        comment = Comment.create! service_comment_valid_attributes
        get :index, params: { review_id: comment.commentable.id }

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
