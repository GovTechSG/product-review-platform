require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Reviews", type: :request do
  let(:valid_product_review) do
    build(:product_review).attributes
  end

  let(:create_update_product_review) do
    value = build(:product_review).attributes
    value["from_id"] = Company.find(value["reviewer_id"]).hashid
    value["from_type"] = value["reviewer_type"]
    value.delete("reviewer_id")
    value.delete("reviewer_type")

    reviewable = Product.find(value["reviewable_id"])
    value["reviewable_id"] = reviewable.hashid

    grant = Grant.find(value["grant_id"])
    value["grant_id"] = grant.hashid

    value["vendor_name"] = @company.name
    value
  end

  let(:invalid_product_review) do
    attributes_for(:product_review, score: nil, content: nil)
  end

  let(:valid_service_review) do
    build(:service_review).attributes
  end

  let(:create_update_service_review) do
    value = build(:service_review).attributes
    value["from_id"] = Company.find(value["reviewer_id"]).hashid
    value["from_type"] = value["reviewer_type"]
    value.delete("reviewer_id")
    value.delete("reviewer_type")

    reviewable = Service.find(value["reviewable_id"])
    value["reviewable_id"] = reviewable.hashid

    grant = Grant.find(value["grant_id"])
    value["grant_id"] = grant.hashid
    value["vendor_name"] = @company.name
    value
  end

  let(:invalid_service_review) do
    attributes_for(:service_review, score: nil, content: nil)
  end

  before(:each) do
    @company_reviewable = create(:company_product)
    @product = @company_reviewable.reviewable
    @company = @company_reviewable.company
    @service = @company.services.create!(build(:service).attributes)
    @product_review = @product.reviews.create!(build(:product_review, vendor_id: @company.id).attributes)
    @service_review = @service.reviews.create!(build(:service_review, vendor_id: @company.id).attributes)
  end

  describe "Authorised user" do
    describe "GET api/v1/products/:product_id/reviews" do
      it "returns a success response" do
        get product_reviews_path(@product.hashid), headers: request_login

        expect(response).to be_success
      end

      it "returns a not found response when product not found", authorized: true do
        get product_reviews_path(0), headers: request_login
        expect(response).to be_not_found
      end

      it "returns a not found response when the product is deleted", authorized: true do
        @product.discard
        get product_reviews_path(@product.hashid), headers: request_login

        expect(response).to be_not_found
      end

      it "returns a not found response when the company is deleted", authorized: true do
        @company.discard
        get product_reviews_path(@product.hashid), headers: request_login
        expect(response).to be_not_found
      end

      it "does not return deleted reviews", authorized: true do
        @product_review.discard
        get product_reviews_path(@product.hashid), headers: request_login

        expect(parsed_response).to match([])
        expect(response).to be_success
      end
    end

    describe "GET api/v1/services/:service_id/reviews" do
      it "returns a success response" do
        get service_reviews_path(@service.hashid), headers: request_login

        expect(response).to be_success
      end

      it "returns a not found response when service not found" do
        get service_reviews_path(0), headers: request_login
        expect(response).to be_not_found
      end

      it "returns a not found response when the service is deleted", authorized: true do
        @service.discard
        get service_reviews_path(@service.hashid), headers: request_login

        expect(response).to be_not_found
      end

      it "returns a not found response when the company is deleted", authorized: true do
        @company.discard
        get service_reviews_path(@service.hashid), headers: request_login
        expect(response).to be_not_found
      end

      it "does not return deleted reviews", authorized: true do
        @service_review.discard
        get service_reviews_path(@service.hashid), headers: request_login

        expect(parsed_response).to match([])
        expect(response).to be_success
      end
    end

    describe "GET api/v1/reviews/:id" do
      it "returns a success response" do
        get review_path(@product_review.hashid), headers: request_login
        expect(response).to be_success
      end

      it "returns not found when review not found" do
        get review_path(0), headers: request_login
        expect(response).to be_not_found
      end

      it "returns a not found when the review is deleted", authorized: true do
        @product_review.discard
        get review_path(@product_review.hashid), headers: request_login
        expect(response).to be_not_found
      end

      it "returns a not found when the reviewable is deleted", authorized: true do
        @product.discard
        get review_path(@product_review.hashid), headers: request_login
        expect(response).to be_not_found
      end

      it "returns a not found when the company is deleted", authorized: true do
        @company.discard
        get review_path(@product_review.hashid), headers: request_login
        expect(response).to be_not_found
      end
    end

    describe "POST api/v1/products/:product_id/reviews" do
      context "with valid params" do
        it "creates a new Review" do
          expect do
            post product_reviews_path(@product.hashid), params: { review: create_update_product_review }, headers: request_login
          end.to change(Review, :count).by(1)
        end

        it "renders a JSON response with the new review" do
          post product_reviews_path(@product.hashid), params: { review: create_update_product_review }, headers: request_login
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(review_url(Review.last))
        end

        it "return 404 when grant id is not found", authorized: true do
          create_update_product_review["grant_id"] = 0
          post product_reviews_path(@product.hashid), params: { review: create_update_product_review }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end

        it "return 404 when from id is not found", authorized: true do
          create_update_product_review["from_id"] = 0
          post product_reviews_path(@product.hashid), params: { review: create_update_product_review }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end

        it "return 422 when from type is not subclass of reviewer", authorized: true do
          create_update_product_review["from_type"] = "agency"
          post product_reviews_path(@product.hashid), params: { review: create_update_product_review }, headers: request_login
          expect(response).to have_http_status(422)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted product" do
        it "does not creates a new Review", authorized: true do
          expect do
            @product.discard
            post product_reviews_path(@product.hashid), params: { review: create_update_product_review }, headers: request_login
          end.to change(Review, :count).by(0)
        end

        it "renders a not found response", authorized: true do
          @product.discard
          post product_reviews_path(@product.hashid), params: { review: create_update_product_review }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted company" do
        it "does not creates a new Review", authorized: true do
          expect do
            @company.discard
            post product_reviews_path(@product.hashid), params: { review: create_update_product_review }, headers: request_login
          end.to change(Review, :count).by(0)
        end

        it "renders a not found response", authorized: true do
          @company.discard
          post product_reviews_path(@product.hashid), params: { review: create_update_product_review }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the new review" do
          post product_reviews_path(@product.hashid), params: { review: invalid_product_review }, headers: request_login
          expect(response).to have_http_status(400)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with non existent reviewable id" do
        it "renders a JSON response with errors for the new review" do
          post product_reviews_path(0), params: { review: create_update_product_review }, headers: request_login
          expect(response).to be_not_found
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "POST api/v1/services/:serivce_id/reviews" do
      context "with valid params" do
        it "creates a new Review" do
          expect do
            post service_reviews_path(@service.hashid), params: { review: create_update_service_review }, headers: request_login
          end.to change(Review, :count).by(1)
        end

        it "renders a JSON response with the new review" do
          post service_reviews_path(@service.hashid), params: { review: create_update_service_review }, headers: request_login
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(review_url(Review.last))
        end

        it "return 404 when grant id is not found", authorized: true do
          create_update_service_review["grant_id"] = 0
          post product_reviews_path(@product.hashid), params: { review: create_update_service_review }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end

        it "return 404 when from id is not found", authorized: true do
          create_update_service_review["from_id"] = 0
          post product_reviews_path(@product.hashid), params: { review: create_update_service_review }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end

        it "return 422 when from type is not subclass of reviewer", authorized: true do
          create_update_service_review["from_type"] = "agency"
          post product_reviews_path(@product.hashid), params: { review: create_update_service_review }, headers: request_login
          expect(response).to have_http_status(422)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted service" do
        it "does not creates a new Review", authorized: true do
          expect do
            @service.discard
            post service_reviews_path(@service.hashid), params: { review: create_update_service_review }, headers: request_login
          end.to change(Review, :count).by(0)
        end

        it "renders a not found response", authorized: true do
          @service.discard
          post service_reviews_path(@service.hashid), params: { review: create_update_service_review }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted company" do
        it "does not creates a new Review", authorized: true do
          @company.discard
          expect do
            post service_reviews_path(@service.hashid), params: { review: create_update_service_review }, headers: request_login
          end.to change(Review, :count).by(0)
        end

        it "renders a not found response", authorized: true do
          @company.discard
          post service_reviews_path(@service.hashid), params: { review: create_update_service_review }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the new review" do
          post service_reviews_path(@service.hashid), params: { review: invalid_service_review }, headers: request_login
          expect(response).to have_http_status(400)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with non existent reviewable id" do
        it "renders a JSON response with errors for the new review" do
          post service_reviews_path(0), params: { review: create_update_service_review }, headers: request_login
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
          put review_path(@product_review.hashid), params: { review: new_attributes }, headers: request_login
          @product_review.reload
          expect(@product_review.score).to eq(new_attributes[:score])
          expect(@product_review.content).to eq(new_attributes[:content])
        end

        it "renders a JSON response with the review" do
          put review_path(@product_review.hashid), params: { review: new_attributes }, headers: request_login
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end

        it "return 404 when grant id is not found", authorized: true do
          create_update_product_review["grant_id"] = 0
          put review_path(@product_review.hashid), params: { review: create_update_product_review }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end

        it "return 404 when from id is not found", authorized: true do
          create_update_product_review["from_id"] = 0
          put review_path(@product_review.hashid), params: { review: create_update_product_review }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end

        it "return 422 when from type is not subclass of reviewer", authorized: true do
          create_update_product_review["from_type"] = "agency"
          put review_path(@product_review.hashid), params: { review: create_update_product_review }, headers: request_login
          expect(response).to have_http_status(422)
          expect(response.content_type).to eq('application/json')
        end

        it "return 422 when from type is missing", authorized: true do
          create_update_product_review.delete("from_type")
          put review_path(@product_review.hashid), params: { review: create_update_product_review }, headers: request_login
          expect(response).to have_http_status(422)
          expect(response.content_type).to eq('application/json')
        end

        it "return 422 when from id is missing", authorized: true do
          create_update_product_review.delete("from_id")
          put review_path(@product_review.hashid), params: { review: create_update_product_review }, headers: request_login
          expect(response).to have_http_status(422)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted review" do
        it "does not updates the requested review", authorized: true do
          original_review = @product_review
          @product_review.discard
          put review_path(@product_review.hashid), params: { review: new_attributes }, headers: request_login
          @product_review.reload
          expect(@product_review.score).to eq(original_review[:score])
          expect(@product_review.content).to eq(original_review[:content])
        end

        it "renders a not found response", authorized: true do
          @product_review.discard
          put review_path(@product_review.hashid), params: { review: new_attributes }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted reviewable" do
        it "does not updates the requested review", authorized: true do
          original_review = @product_review
          @product.discard
          put review_path(@product_review.hashid), params: { review: new_attributes }, headers: request_login
          @product_review.reload
          expect(@product_review.score).to eq(original_review[:score])
          expect(@product_review.content).to eq(original_review[:content])
        end

        it "renders a not found response", authorized: true do
          @product.discard
          put review_path(@product_review.hashid), params: { review: new_attributes }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted company" do
        it "does not updates the requested review", authorized: true do
          original_review = @product_review
          @company.discard
          put review_path(@product_review.hashid), params: { review: new_attributes }, headers: request_login
          @product_review.reload
          expect(@product_review.score).to eq(original_review[:score])
          expect(@product_review.content).to eq(original_review[:content])
        end

        it "renders a not found response", authorized: true do
          @company.discard
          put review_path(@product_review.hashid), params: { review: new_attributes }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the review" do
          put review_path(@product_review.hashid), params: { review: invalid_product_review }, headers: request_login
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
        expect do
          delete review_path(@product_review.hashid), headers: request_login
        end.to change(Review, :count).by(0)
      end

      it "sets discarded_at datetime" do
        delete review_path(@product_review.hashid), headers: request_login
        @product_review.reload
        expect(@product_review.discarded?).to be true
      end

      it "renders a JSON response with the review" do
        delete review_path(@product_review.hashid), headers: request_login
        expect(response).to have_http_status(204)
      end

      it "returns a not found response when review deleted", authorized: true do
        @product_review.discard
        delete review_path(@product_review.hashid), headers: request_login
        expect(response).to be_not_found
      end

      it "returns a not found response when reviewable deleted", authorized: true do
        @product.discard
        delete review_path(@product_review.hashid), headers: request_login
        expect(response).to be_not_found
      end

      it "returns a not found response when company deleted", authorized: true do
        @company.discard
        delete review_path(@product_review.hashid), headers: request_login
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
        get product_reviews_path(@product), headers: nil

        expect_unauthorized
      end
    end

    describe "GET api/v1/reviews/:id" do
      it "returns an unauthorized response" do
        get review_path(@product_review.hashid), headers: nil

        expect_unauthorized
      end
    end

    describe "POST api/v1/products/:product_id/reviews" do
      it "does not create a new Review" do
        expect do
          post product_reviews_path(@product.hashid), params: { review: valid_product_review }, headers: nil
        end.to change(Review, :count).by(0)
      end

      it "returns an unauthorized response" do
        post product_reviews_path(@product.hashid), params: { review: valid_product_review }, headers: nil
        expect_unauthorized
      end
    end

    describe "PUT api/v1/reviews/:id" do
      let(:new_attributes) do
        attributes_for(:service_review)
      end

      it "does not update the requested review" do
        current_attributes = @product_review.attributes

        put review_path(@product_review.hashid), params: { review: valid_product_review }, headers: nil
        @product_review.reload
        expect(@product_review.score).to eq(current_attributes["score"])
        expect(@product_review.content).to eq(current_attributes["content"])
        expect(@product_review.reviewable_id).to eq(current_attributes["reviewable_id"])
        expect(@product_review.reviewable_type).to eq(current_attributes["reviewable_type"])
        expect(@product_review.reviewer_id).to eq(current_attributes["reviewer_id"])
      end

      it "returns an unauthorized response" do
        put review_path(@product_review.hashid), params: { review: valid_product_review }, headers: nil
        expect_unauthorized
      end
    end

    describe "DELETE api/v1/reviews/:id" do
      it "does not destroy the requested review" do
        expect do
          delete review_path(@product_review.hashid), headers: nil
        end.to change(Review, :count).by(0)
      end

      it "does not set discarded_at datetime" do
        delete review_path(@product_review.hashid), headers: nil
        @product_review.reload
        expect(@product_review.discarded?).to be false
      end

      it "returns an unauthorized response" do
        delete review_path(@product_review.hashid), headers: nil
        expect_unauthorized
      end
    end
  end
end
