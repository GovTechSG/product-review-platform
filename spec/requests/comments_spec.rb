require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Comments", type: :request do
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

  describe "Authorised user" do
    describe "GET /api/v1/reviews/:review_id/comments" do
      it "returns a success response from a product comment" do
        comment = Comment.create! product_comment_valid_attributes
        get review_comments_path(comment.review.id), headers: request_login

        expect(response).to be_success
      end

      it "returns a success response from a service comment" do
        comment = Comment.create! service_comment_valid_attributes
        get review_comments_path(comment.review.id), headers: request_login

        expect(response).to be_success
      end

      it "returns not found when product not found" do
        get review_comments_path(0), headers: request_login
        expect(response).to be_not_found
      end
    end

    describe "GET api/v1/comments/:id" do
      it "returns a success response from a product comment" do
        comment = Comment.create! product_comment_valid_attributes
        get comment_path(comment.id), headers: request_login
        expect(response).to be_success
      end

      it "returns a success response from a service comment" do
        comment = Comment.create! service_comment_valid_attributes
        get comment_path(comment.id), headers: request_login
        expect(response).to be_success
      end

      it "returns not found when comment not found" do
        get comment_path(0), headers: request_login
        expect(response).to be_not_found
      end
    end

    describe "POST /api/v1/reviews/:review_id/comments" do
      context "with valid params" do
        it "creates a new Comment to product" do
          review = create(:product_review)

          expect do
            post review_comments_path(review.id), params: { comment: product_comment_valid_attributes }, headers: request_login
          end.to change(Comment, :count).by(1)
        end

        it "creates a new Comment to service" do
          review = create(:service_review)

          expect do
            post review_comments_path(review.id), params: { comment: service_comment_valid_attributes }, headers: request_login
          end.to change(Comment, :count).by(1)
        end

        it "renders a JSON response with the new comment to product" do
          review = create(:product_review)

          post review_comments_path(review.id), params: { comment: product_comment_valid_attributes }, headers: request_login
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(comment_url(Comment.last))
        end

        it "renders a JSON response with the new comment to service" do
          review = create(:service_review)

          post review_comments_path(review.id), params: { comment: service_comment_valid_attributes }, headers: request_login
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(comment_url(Comment.last))
        end

        it "returns not found when product_review_id not found" do
          post review_comments_path(0), params: { comment: product_comment_valid_attributes }, headers: request_login
          expect(response).to be_not_found
        end

        it "returns not found when service_review_id not found" do
          post review_comments_path(0), params: { comment: service_comment_valid_attributes }, headers: request_login
          expect(response).to be_not_found
        end

        it "returns not found when product_user_id not found" do
          review = create(:product_review)

          post review_comments_path(review.id), params: { comment: product_comment_missing_userid_attributes }, headers: request_login
          expect(response).to be_not_found
        end

        it "returns not found when service_user_id not found" do
          review = create(:service_review)

          post review_comments_path(review.id), params: { comment: service_comment_missing_userid_attributes }, headers: request_login
          expect(response).to be_not_found
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the new comment on product" do
          review = create(:product_review)

          post review_comments_path(review.id), params: { comment: product_comment_invalid_attributes }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "renders a JSON response with errors for the new comment on service" do
          review = create(:service_review)

          post review_comments_path(review.id), params: { comment: service_comment_invalid_attributes }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "PUT /api/v1/comments/:id" do
      context "with valid params" do
        let(:product_comment_new_attributes) do
          attributes_for(:product_review_comment)
        end

        let(:service_comment_new_attributes) do
          attributes_for(:service_review_comment)
        end

        it "updates the requested product_comment" do
          comment = Comment.create! product_comment_valid_attributes

          put comment_path(comment), params: { comment: product_comment_new_attributes }, headers: request_login
          comment.reload
          expect(comment.content).to eq(product_comment_new_attributes[:content])
        end

        it "renders a JSON response with the product_comment" do
          comment = Comment.create! product_comment_valid_attributes

          put comment_path(comment), params: { comment: product_comment_new_attributes }, headers: request_login
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end

        it "updates the requested service_comment" do
          comment = Comment.create! service_comment_valid_attributes

          put comment_path(comment), params: { comment: service_comment_new_attributes }, headers: request_login
          comment.reload
          expect(comment.content).to eq(service_comment_new_attributes[:content])
        end

        it "renders a JSON response with the service_comment" do
          comment = Comment.create! service_comment_valid_attributes

          put comment_path(comment), params: { comment: service_comment_new_attributes }, headers: request_login
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end

        it "returns not found when comment ID not found" do
          put comment_path(0), params: { comment: product_comment_new_attributes }, headers: request_login
          expect(response).to be_not_found
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the product_comment" do
          comment = Comment.create! product_comment_valid_attributes

          put comment_path(comment), params: { comment: product_comment_invalid_attributes }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "renders a JSON response with errors for the service_comment" do
          comment = Comment.create! service_comment_valid_attributes

          put comment_path(comment), params: { comment: service_comment_invalid_attributes }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "DELETE /api/v1/comments/:id" do
      it "soft deletes product_comment" do
        comment = Comment.create! product_comment_valid_attributes
        expect do
          delete comment_path(comment.id), params: {}, headers: request_login
        end.to change(Comment, :count).by(0)
      end

      it "soft deletes service_comment" do
        comment = Comment.create! service_comment_valid_attributes
        expect do
          delete comment_path(comment.id), params: {}, headers: request_login
        end.to change(Comment, :count).by(0)
      end

      it "sets discarded_at datetime for product_comment" do
        comment = Comment.create! product_comment_valid_attributes
        delete comment_path(comment.id), params: {}, headers: request_login
        comment.reload
        expect(comment.discarded?).to be true
      end

      it "sets discarded_at datetime for service_comment" do
        comment = Comment.create! service_comment_valid_attributes
        delete comment_path(comment.id), params: {}, headers: request_login
        comment.reload
        expect(comment.discarded?).to be true
      end

      it "renders a JSON response with the product_comment" do
        comment = Comment.create! product_comment_valid_attributes

        delete comment_path(comment.id), params: {}, headers: request_login
        expect(response).to have_http_status(204)
      end

      it "renders a JSON response with the service_comment" do
        comment = Comment.create! service_comment_valid_attributes

        delete comment_path(comment.id), params: {}, headers: request_login
        expect(response).to have_http_status(204)
      end

      it "returns a not found response when comment not found" do
        delete comment_path(0), params: {}, headers: request_login
        expect(response).to be_not_found
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET /api/v1/reviews/:review_id/comments" do
      it "returns an unauthorized response from product_comment" do
        comment = Comment.create! product_comment_valid_attributes
        get review_comments_path(comment.review.id), headers: nil

        expect_unauthorized
      end

      it "returns an unauthorized response from service_comment" do
        comment = Comment.create! service_comment_valid_attributes
        get review_comments_path(comment.review.id), headers: nil

        expect_unauthorized
      end
    end

    describe "GET api/v1/comments/:id" do
      it "returns an unauthorized response from product_comment" do
        comment = Comment.create! product_comment_valid_attributes
        get comment_path(comment.id), headers: nil

        expect_unauthorized
      end

      it "returns an unauthorized response from service_comment" do
        comment = Comment.create! service_comment_valid_attributes
        get comment_path(comment.id), headers: nil

        expect_unauthorized
      end
    end

    describe "POST /api/v1/reviews/:review_id/comments" do
      it "does not create a new product_comment" do
        review = create(:product_review)

        expect do
          post review_comments_path(review.id), params: { comment: product_comment_valid_attributes }, headers: nil
        end.to change(Comment, :count).by(0)
      end

      it "returns an unauthorized response from product_comment" do
        review = create(:product_review)

        post review_comments_path(review.id), params: { comment: product_comment_valid_attributes }, headers: nil
        expect_unauthorized
      end

      it "does not create a new service_comment" do
        review = create(:service_review)

        expect do
          post review_comments_path(review.id), params: { comment: product_comment_valid_attributes }, headers: nil
        end.to change(Comment, :count).by(0)
      end

      it "returns an unauthorized response from service_comment" do
        review = create(:service_review)

        post review_comments_path(review.id), params: { comment: product_comment_valid_attributes }, headers: nil
        expect_unauthorized
      end
    end

    describe "PUT /api/v1/comments/:id" do
      let(:product_comment_new_attributes) do
        attributes_for(:product_review_comment)
      end

      let(:service_comment_new_attributes) do
        attributes_for(:service_review_comment)
      end

      it "does not update the requested product_comment" do
        comment = Comment.create! product_comment_valid_attributes
        current_attributes = comment.attributes

        put comment_path(comment), params: { comment: product_comment_new_attributes }, headers: nil
        comment.reload
        expect(comment.content).to eq(current_attributes["content"])
      end

      it "returns an unauthorized response for product_comment" do
        comment = Comment.create! product_comment_valid_attributes

        put comment_path(comment), params: { comment: product_comment_new_attributes }, headers: nil
        expect_unauthorized
      end

      it "does not update the requested service_comment" do
        comment = Comment.create! service_comment_valid_attributes
        current_attributes = comment.attributes

        put comment_path(comment), params: { comment: product_comment_new_attributes }, headers: nil
        comment.reload
        expect(comment.content).to eq(current_attributes["content"])
      end

      it "returns an unauthorized response for service_comment" do
        comment = Comment.create! service_comment_valid_attributes

        put comment_path(comment), params: { comment: product_comment_new_attributes }, headers: nil
        expect_unauthorized
      end
    end

    describe "DELETE /api/v1/comments/:id" do
      it "does not destroy the requested product_comment" do
        comment = Comment.create! product_comment_valid_attributes
        expect do
          delete comment_path(comment.id), params: {}, headers: nil
        end.to change(Comment, :count).by(0)
      end

      it "does not set discarded_at datetime for product_comment" do
        comment = Comment.create! product_comment_valid_attributes
        delete comment_path(comment.id), params: {}, headers: nil
        comment.reload
        expect(comment.discarded?).to be false
      end

      it "returns an unauthorized response for product_comment" do
        comment = Comment.create! product_comment_valid_attributes

        delete comment_path(comment.id), params: {}, headers: nil
        expect_unauthorized
      end

      it "does not destroy the requested service_comment" do
        comment = Comment.create! service_comment_valid_attributes
        expect do
          delete comment_path(comment.id), params: {}, headers: nil
        end.to change(Comment, :count).by(0)
      end

      it "does not set discarded_at datetime for service_comment" do
        comment = Comment.create! service_comment_valid_attributes
        delete comment_path(comment.id), params: {}, headers: nil
        comment.reload
        expect(comment.discarded?).to be false
      end

      it "returns an unauthorized response for service_comment" do
        comment = Comment.create! service_comment_valid_attributes

        delete comment_path(comment.id), params: {}, headers: nil
        expect_unauthorized
      end
    end
  end
end
