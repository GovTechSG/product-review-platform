require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Reviews", type: :request do
  let(:valid_product_review) do
    build(:product_review).attributes
  end

  let(:invalid_product_review) do
    attributes_for(:product_review, score: nil, content: nil)
  end

  let(:valid_service_review) do
    build(:service_review).attributes
  end

  let(:invalid_service_review) do
    attributes_for(:service_review, score: nil, content: nil)
  end

  describe "Authorised user" do
    describe "GET api/v1/products/:product_id/reviews" do
      it "returns a success response" do
        review = Review.create! valid_product_review
        get product_reviews_path(review.reviewable_id), headers: request_login

        expect(response).to be_success
      end

      it "returns a not found response when product not found", authorized: true do
        get product_reviews_path(0), headers: request_login
        expect(response).to be_not_found
      end

      it "returns a not found response when the product is deleted", authorized: true do
        review = Review.create! valid_product_review
        review.reviewable.discard
        get product_reviews_path(review.reviewable_id), headers: request_login

        expect(response).to be_not_found
      end

      it "returns a not found response when the company is deleted", authorized: true do
        review = Review.create! valid_product_review
        review.reviewable.company.discard
        get product_reviews_path(review.reviewable_id), headers: request_login
        expect(response).to be_not_found
      end

      it "does not return deleted reviews", authorized: true do
        review = Review.create! valid_product_review
        review.discard
        get product_reviews_path(review.reviewable_id), headers: request_login

        expect(parsed_response).to match([])
        expect(response).to be_success
      end
    end

    describe "GET api/v1/services/:service_id/reviews" do
      it "returns a success response" do
        review = Review.create! valid_service_review
        get service_reviews_path(review.reviewable_id), headers: request_login

        expect(response).to be_success
      end

      it "returns a not found response when service not found" do
        get service_reviews_path(0), headers: request_login
        expect(response).to be_not_found
      end

      it "returns a not found response when the service is deleted", authorized: true do
        review = Review.create! valid_service_review
        review.reviewable.discard
        get service_reviews_path(review.reviewable_id), headers: request_login

        expect(response).to be_not_found
      end

      it "returns a not found response when the company is deleted", authorized: true do
        review = Review.create! valid_service_review
        review.reviewable.company.discard
        get service_reviews_path(review.reviewable_id), headers: request_login
        expect(response).to be_not_found
      end

      it "does not return deleted reviews", authorized: true do
        review = Review.create! valid_service_review
        review.discard
        get service_reviews_path(review.reviewable_id), headers: request_login

        expect(parsed_response).to match([])
        expect(response).to be_success
      end
    end

    describe "GET api/v1/reviews/:id" do
      it "returns a success response" do
        review = Review.create! valid_product_review
        get review_path(review.id), headers: request_login
        expect(response).to be_success
      end

      it "returns not found when review not found" do
        get review_path(0), headers: request_login
        expect(response).to be_not_found
      end

      it "returns a not found when the review is deleted", authorized: true do
        review = Review.create! valid_product_review
        review.discard
        get review_path(review.id), headers: request_login
        expect(response).to be_not_found
      end

      it "returns a not found when the reviewable is deleted", authorized: true do
        review = Review.create! valid_product_review
        review.reviewable.discard
        get review_path(review.id), headers: request_login
        expect(response).to be_not_found
      end

      it "returns a not found when the company is deleted", authorized: true do
        review = Review.create! valid_product_review
        review.reviewable.company.discard
        get review_path(review.id), headers: request_login
        expect(response).to be_not_found
      end
    end

    describe "POST api/v1/products/:product_id/reviews" do
      context "with valid params" do
        it "creates a new Review" do
          product = create(:product)

          expect do
            post product_reviews_path(product.id), params: { review: valid_product_review }, headers: request_login
          end.to change(Review, :count).by(1)
        end

        it "renders a JSON response with the new review" do
          product = create(:product)

          post product_reviews_path(product.id), params: { review: valid_product_review }, headers: request_login
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(review_url(Review.last))
        end
      end

      context "with deleted product" do
        it "does not creates a new Review", authorized: true do
          product = create(:product)
          product.discard
          expect do
            post product_reviews_path(product.id), params: { review: valid_product_review }, headers: request_login
          end.to change(Review, :count).by(0)
        end

        it "renders a not found response", authorized: true do
          product = create(:product)
          product.discard
          post product_reviews_path(product.id), params: { review: valid_product_review }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted company" do
        it "does not creates a new Review", authorized: true do
          product = create(:product)
          product.company.discard
          expect do
            post product_reviews_path(product.id), params: { review: valid_product_review }, headers: request_login
          end.to change(Review, :count).by(0)
        end

        it "renders a not found response", authorized: true do
          product = create(:product)
          product.company.discard
          post product_reviews_path(product.id), params: { review: valid_product_review }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the new review" do
          product = create(:product)
          post product_reviews_path(product.id), params: { review: invalid_product_review }, headers: request_login
          expect(response).to have_http_status(400)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with non existent reviewable id" do
        it "renders a JSON response with errors for the new review" do
          post product_reviews_path(0), params: { review: valid_product_review }, headers: request_login
          expect(response).to be_not_found
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "POST api/v1/services/:serivce_id/reviews" do
      context "with valid params" do
        it "creates a new Review" do
          service = create(:service)

          expect do
            post service_reviews_path(service.id), params: { review: valid_service_review }, headers: request_login
          end.to change(Review, :count).by(1)
        end

        it "renders a JSON response with the new review" do
          service = create(:service)

          post service_reviews_path(service.id), params: { review: valid_service_review }, headers: request_login
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(review_url(Review.last))
        end
      end

      context "with deleted service" do
        it "does not creates a new Review", authorized: true do
          service = create(:service)
          service.discard
          expect do
            post service_reviews_path(service.id), params: { review: valid_service_review }, headers: request_login
          end.to change(Review, :count).by(0)
        end

        it "renders a not found response", authorized: true do
          service = create(:service)
          service.discard
          post service_reviews_path(service.id), params: { review: valid_service_review }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted company" do
        it "does not creates a new Review", authorized: true do
          service = create(:service)
          service.company.discard
          expect do
            post service_reviews_path(service.id), params: { review: valid_service_review }, headers: request_login
          end.to change(Review, :count).by(0)
        end

        it "renders a not found response", authorized: true do
          service = create(:service)
          service.company.discard
          post service_reviews_path(service.id), params: { review: valid_service_review }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the new review" do
          service = create(:service)

          post service_reviews_path(service.id), params: { review: invalid_service_review }, headers: request_login
          expect(response).to have_http_status(400)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with non existent reviewable id" do
        it "renders a JSON response with errors for the new review" do
          post service_reviews_path(0), params: { review: valid_service_review }, headers: request_login
          expect(response).to be_not_found
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "PUT api/v1/reviews/:id" do
      let(:new_attributes) do
        attributes_for(:product_review)
      end
      context "with valid params" do
        it "updates the requested review" do
          review = Review.create! valid_product_review
          put review_path(review.id), params: { review: new_attributes }, headers: request_login
          review.reload
          expect(review.score).to eq(new_attributes[:score])
          expect(review.content).to eq(new_attributes[:content])
          expect(review.strengths).to eq(new_attributes[:strengths])
        end

        it "renders a JSON response with the review" do
          review = Review.create! valid_product_review

          put review_path(review.id), params: { review: new_attributes }, headers: request_login
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted review" do
        it "does not updates the requested review", authorized: true do
          review = Review.create! valid_product_review
          original_review = review
          review.discard
          put review_path(review.id), params: { review: new_attributes }, headers: request_login
          review.reload
          expect(review.score).to eq(original_review[:score])
          expect(review.content).to eq(original_review[:content])
          expect(review.strengths).to eq(original_review[:strengths])
        end

        it "renders a not found response", authorized: true do
          review = Review.create! valid_product_review
          review.discard
          put review_path(review.id), params: { review: new_attributes }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted reviewable" do
        it "does not updates the requested review", authorized: true do
          review = Review.create! valid_product_review
          original_review = review
          review.reviewable.discard
          put review_path(review.id), params: { review: new_attributes }, headers: request_login
          review.reload
          expect(review.score).to eq(original_review[:score])
          expect(review.content).to eq(original_review[:content])
          expect(review.strengths).to eq(original_review[:strengths])
        end

        it "renders a not found response", authorized: true do
          review = Review.create! valid_product_review
          review.reviewable.discard
          put review_path(review.id), params: { review: new_attributes }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted company" do
        it "does not updates the requested review", authorized: true do
          review = Review.create! valid_product_review
          original_review = review
          review.reviewable.company.discard
          put review_path(review.id), params: { review: new_attributes }, headers: request_login
          review.reload
          expect(review.score).to eq(original_review[:score])
          expect(review.content).to eq(original_review[:content])
          expect(review.strengths).to eq(original_review[:strengths])
        end

        it "renders a not found response", authorized: true do
          review = Review.create! valid_product_review
          review.reviewable.company.discard
          put review_path(review.id), params: { review: new_attributes }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the review" do
          review = Review.create! valid_product_review

          put review_path(review.id), params: { review: invalid_product_review }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with non existent review id" do
        it "renders a not found JSON response" do
          put review_path(0), params: { review: valid_product_review }, headers: request_login
          expect(response).to be_not_found
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "DELETE api/v1/reviews/:id" do
      it "soft deletes" do
        review = Review.create! valid_product_review
        expect do
          delete review_path(review.id), headers: request_login
        end.to change(Review, :count).by(0)
      end

      it "sets discarded_at datetime" do
        review = Review.create! valid_product_review
        delete review_path(review.id), headers: request_login
        review.reload
        expect(review.discarded?).to be true
      end

      it "renders a JSON response with the review" do
        review = Review.create! valid_product_review

        delete review_path(review.id), headers: request_login
        expect(response).to have_http_status(204)
      end

      it "returns a not found response when review deleted", authorized: true do
        review = Review.create! valid_product_review
        review.discard
        delete review_path(review.id), headers: request_login
        expect(response).to be_not_found
      end

      it "returns a not found response when reviewable deleted", authorized: true do
        review = Review.create! valid_product_review
        review.reviewable.discard
        delete review_path(review.id), headers: request_login
        expect(response).to be_not_found
      end

      it "returns a not found response when company deleted", authorized: true do
        review = Review.create! valid_product_review
        review.reviewable.company.discard
        delete review_path(review.id), headers: request_login
        expect(response).to be_not_found
      end

      it "returns a not found response when review not found" do
        delete review_path(0), headers: request_login
        expect(response).to be_not_found
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET api/v1/products/:product_id/reviews" do
      it "returns an unauthorized response" do
        review = Review.create! valid_product_review
        get product_reviews_path(review.reviewable_id), headers: nil

        expect_unauthorized
      end
    end

    describe "GET api/v1/reviews/:id" do
      it "returns an unauthorized response" do
        review = Review.create! valid_product_review
        get review_path(review.id), headers: nil

        expect_unauthorized
      end
    end

    describe "POST api/v1/products/:product_id/reviews" do
      it "does not create a new Review" do
        product = create(:product)

        expect do
          post product_reviews_path(product.id), params: { review: valid_product_review }, headers: nil
        end.to change(Review, :count).by(0)
      end

      it "returns an unauthorized response" do
        product = create(:product)

        post product_reviews_path(product.id), params: { review: valid_product_review }, headers: nil
        expect_unauthorized
      end
    end

    describe "PUT api/v1/reviews/:id" do
      let(:new_attributes) do
        attributes_for(:service_review)
      end

      it "does not update the requested review" do
        review = Review.create! valid_product_review
        current_attributes = review.attributes

        put review_path(review.id), params: { review: valid_product_review }, headers: nil
        review.reload
        expect(review.score).to eq(current_attributes["score"])
        expect(review.content).to eq(current_attributes["content"])
        expect(review.reviewable_id).to eq(current_attributes["reviewable_id"])
        expect(review.reviewable_type).to eq(current_attributes["reviewable_type"])
        expect(review.strengths).to eq(current_attributes["strengths"])
        expect(review.reviewer_id).to eq(current_attributes["reviewer_id"])
      end

      it "returns an unauthorized response" do
        review = Review.create! valid_product_review

        put review_path(review.id), params: { review: valid_product_review }, headers: nil
        expect_unauthorized
      end
    end

    describe "DELETE api/v1/reviews/:id" do
      it "does not destroy the requested review" do
        review = Review.create! valid_product_review
        expect do
          delete review_path(review.id), headers: nil
        end.to change(Review, :count).by(0)
      end

      it "does not set discarded_at datetime" do
        review = Review.create! valid_product_review
        delete review_path(review.id), headers: nil
        review.reload
        expect(review.discarded?).to be false
      end

      it "returns an unauthorized response" do
        review = Review.create! valid_product_review
        delete review_path(review.id), headers: nil
        expect_unauthorized
      end
    end
  end
end
