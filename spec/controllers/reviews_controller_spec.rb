require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe ReviewsController, type: :controller do
  let(:valid_product) do
    build(:product_review).attributes
  end

  let(:invalid_product) do
    build(:product_review, name: nil, description: nil, company_id: nil).attributes
  end

  let(:valid_service) do
    build(:service_review).attributes
  end

  let(:invalid_service) do
    build(:service_review, name: nil, description: nil, company_id: nil).attributes
  end

  let(:token) { double acceptable?: true }

  before(:each, authorized: true) do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  describe "Authorised user" do
    describe "GET #index" do
      context "product review" do
        it "returns a success response", authorized: true do
          review = Review.create! valid_product
          get :index, params: { product_id: review.reviewable_id }

          expect(response).to be_success
        end

        it "returns a not found response when product not found", authorized: true do
          get :index, params: { product_id: 0 }
          expect(response).to be_not_found
        end
      end

      context "service review" do
        it "returns a success response", authorized: true do
          review = Review.create! valid_service
          get :index, params: { service_id: review.reviewable_id }

          expect(response).to be_success
        end

        it "returns a not found response when service not found", authorized: true do
          get :index, params: { service_id: 0 }
          expect(response).to be_not_found
        end
      end

      context "missing product and service id" do
        it "returns a not found response when no id is given", authorized: true do
          get :index
          expect(response).to be_not_found
        end
      end
    end

    describe "GET #show" do
      it "returns a success response", authorized: true do
        review = Review.create! valid_product
        get :show, params: { id: review.to_param }
        expect(response).to be_success
      end

      it "returns not found when review not found", authorized: true do
        get :show, params: { id: 0 }
        expect(response).to be_not_found
      end
    end

    describe "POST #create" do
      context "product review" do
        context "with valid params" do
          it "creates a new Review", authorized: true do
            product = create(:product)

            expect do
              post :create, params: { review: valid_product, product_id: product.id }
            end.to change(Review, :count).by(1)
          end

          it "renders a JSON response with the new review", authorized: true do
            product = create(:product)

            post :create, params: { review: valid_product, product_id: product.id }
            expect(response).to have_http_status(:created)
            expect(response.content_type).to eq('application/json')
            expect(response.location).to eq(review_url(Review.last))
          end
        end

        context "with invalid params", authorized: true do
          it "renders a JSON response with errors for the new review" do
            product = create(:product)

            post :create, params: { review: invalid_product, product_id: product.id }
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.content_type).to eq('application/json')
          end
        end
      end

      context "service review" do
        context "with valid params" do
          it "creates a new Review", authorized: true do
            service = create(:service)

            expect do
              post :create, params: { review: valid_service, service_id: service.id }
            end.to change(Review, :count).by(1)
          end

          it "renders a JSON response with the new review", authorized: true do
            service = create(:service)

            post :create, params: { review: valid_service, service_id: service.id }
            expect(response).to have_http_status(:created)
            expect(response.content_type).to eq('application/json')
            expect(response.location).to eq(review_url(Review.last))
          end
        end

        context "with invalid params", authorized: true do
          it "renders a JSON response with errors for the new review" do
            service = create(:service)

            post :create, params: { review: invalid_service, service_id: service.id }
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.content_type).to eq('application/json')
          end
        end
      end

      context "missing product and service id" do
        it "returns a not found response when no id is given", authorized: true do
          post :create, params: { review: valid_service }
          expect(response).to be_not_found
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) do
          attributes_for(:review)
        end

        it "updates the requested review", authorized: true do
          review = Review.create! valid_product

          put :update, params: { id: review.to_param, review: new_attributes }, session: valid_session
          review.reload
          expect(review.name).to eq(new_attributes[:name])
          expect(review.description).to eq(new_attributes[:description])
        end

        it "renders a JSON response with the review", authorized: true do
          review = Review.create! valid_product

          put :update, params: { id: review.to_param, review: valid_product }, session: valid_session
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the review", authorized: true do
          review = Review.create! valid_product

          put :update, params: { id: review.to_param, review: invalid_product }, session: valid_session
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "DELETE #destroy" do
      it "soft deletes", authorized: true do
        review = Review.create! valid_product
        expect do
          delete :destroy, params: { id: review.to_param }, session: valid_session
        end.to change(Review, :count).by(0)
      end

      it "sets discarded_at datetime", authorized: true do
        review = Review.create! valid_product
        delete :destroy, params: { id: review.to_param }
        review.reload
        expect(review.discarded?).to be true
      end

      it "renders a JSON response with the review", authorized: true do
        review = Review.create! valid_product

        delete :destroy, params: { id: review.to_param }
        expect(response).to have_http_status(204)
      end

      it "returns a not found response when review not found", authorized: true do
        delete :destroy, params: { id: 0 }
        expect(response).to be_not_found
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET #index" do
      it "returns an unauthorized response", authorized: false do
        review = Review.create! valid_product
        get :index, params: { product_id: review.product.id }

        expect_unauthorized
      end
    end

    describe "GET #show" do
      it "returns an unauthorized response", authorized: false do
        review = Review.create! valid_product
        get :show, params: { id: review.to_param }

        expect_unauthorized
      end
    end

    describe "POST #create" do
      it "does not create a new Review", authorized: false do
        product = create(:product)

        expect do
          post :create, params: { review: valid_product, product_id: product.id }
        end.to change(Review, :count).by(0)
      end

      it "returns an unauthorized response", authorized: false do
        product = create(:product)

        post :create, params: { review: valid_product, product_id: product.id }
        expect_unauthorized
      end
    end

    describe "PUT #update" do
      let(:new_attributes) do
        attributes_for(:review)
      end

      it "does not update the requested review", authorized: false do
        review = Review.create! valid_product
        current_attributes = review.attributes

        put :update, params: { id: review.to_param, review: new_attributes }, session: valid_session
        review.reload
        expect(review.name).to eq(current_attributes["name"])
        expect(review.description).to eq(current_attributes["description"])
      end

      it "returns an unauthorized response", authorized: false do
        review = Review.create! valid_product

        put :update, params: { id: review.to_param, review: valid_product }, session: valid_session
        expect_unauthorized
      end
    end

    describe "DELETE #destroy" do
      it "does not destroy the requested review", authorized: false do
        review = Review.create! valid_product
        expect do
          delete :destroy, params: { id: review.to_param }, session: valid_session
        end.to change(Review, :count).by(0)
      end

      it "does not set discarded_at datetime", authorized: false do
        review = Review.create! valid_product
        delete :destroy, params: { id: review.to_param }
        review.reload
        expect(review.discarded?).to be false
      end

      it "returns an unauthorized response", authorized: false do
        review = Review.create! valid_product

        delete :destroy, params: { id: review.to_param }, session: valid_session
        expect_unauthorized
      end
    end
  end
end