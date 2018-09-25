require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe ReviewsController, type: :controller do
  let(:valid_product_review) do
    build(:product_review).attributes
  end

  let(:create_update_product_review) do
    value = build(:product_review).attributes
    value["from_id"] = Company.find(value["reviewer_id"]).hashid
    value["from_type"] = value["reviewer_type"]
    value.delete("reviewer_id")
    value.delete("reviewer_type")
    value["vendor_id"] = Company.find(value["vendor_id"]).hashid
    value["vendor_uen"] = Company.find(value["vendor_id"]).uen
    value["vendor_name"] = Company.find(value["vendor_id"]).name

    reviewable = Product.find(value["reviewable_id"])
    value["reviewable_id"] = reviewable.hashid

    grant = Grant.find(value["grant_id"])
    value["grant_id"] = grant.hashid
    value
  end

  let(:invalid_product_review) do
    attributes_for(:product_review, score: nil, content: nil, reviewer_id: nil, reviewable_id: nil)
  end

  let(:valid_service_review) do
    build(:service_review).attributes
  end

  let(:create_update_service_review) do
    value = build(:service_review).attributes
    value["from_id"] = Company.find(value["reviewer_id"]).hashid
    value["from_type"] = value["reviewer_type"]
    value["vendor_id"] = Company.find(value["vendor_id"]).hashid
    value["vendor_uen"] = Company.find(value["vendor_id"]).uen
    value["vendor_name"] = Company.find(value["vendor_id"]).name
    value.delete("reviewer_id")
    value.delete("reviewer_type")

    reviewable = Service.find(value["reviewable_id"])
    value["reviewable_id"] = reviewable.hashid

    grant = Grant.find(value["grant_id"])
    value["grant_id"] = grant.hashid
    value
  end

  let(:invalid_service_review) do
    attributes_for(:service_review, score: nil, content: nil, reviewer_id: nil, reviewable_id: nil)
  end

  let(:token) { double acceptable?: true }

  before(:each, authorized: true) do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  describe "Authorised user" do
    describe "GET #index" do
      context "product review" do
        before(:each) do
          @review = create(:product_review)
          @product = @review.reviewable
          @product.companies.create(build(:company_as_params))
        end

        it "returns a success response", authorized: true do
          get :index, params: { product_id: @review.reviewable.hashid }

          expect(response).to be_success
        end

        it "returns 25 result (1 page)", authorized: true do
          default_result_per_page = 25
          num_of_object_to_create = 30

          while num_of_object_to_create > 0
            Review.create! build(:product_review, reviewable: @product).attributes
            num_of_object_to_create -= 1
          end

          get :index, params: { product_id: @product.hashid }
          expect(JSON.parse(response.body).count).to match default_result_per_page
        end

        it "returns a not found response when product not found", authorized: true do
          get :index, params: { product_id: 0 }
          expect(response).to be_not_found
        end

        it "returns a not found response when the product is deleted", authorized: true do
          review = Review.create! valid_product_review
          review.reviewable.discard
          get :index, params: { product_id: review.reviewable_id }

          expect(response).to be_not_found
        end

        it "returns a not found response when the company is deleted", authorized: true do
          @review.reviewable.companies.first.discard
          get :index, params: { product_id: @review.reviewable_id }
          expect(response).to be_not_found
        end

        it "does not return deleted reviews", authorized: true do
          @review.discard
          get :index, params: { product_id: @review.reviewable.hashid }

          expect(parsed_response).to match([])
          expect(response).to be_success
        end
      end

      context "service review" do
        before(:each) do
          @review = create(:service_review)
          @service = @review.reviewable
          @service.companies.create(build(:company_as_params))
        end
        it "returns a success response", authorized: true do
          get :index, params: { service_id: @review.reviewable.hashid }

          expect(response).to be_success
        end

        it "returns 25 result (1 page)", authorized: true do
          default_result_per_page = 25
          num_of_object_to_create = 30

          while num_of_object_to_create > 0
            Review.create! build(:service_review, reviewable: @service).attributes
            num_of_object_to_create -= 1
          end

          get :index, params: { service_id: @service.hashid }
          expect(JSON.parse(response.body).count).to match default_result_per_page
        end

        it "returns a not found response when service not found", authorized: true do
          get :index, params: { service_id: 0 }
          expect(response).to be_not_found
        end

        it "returns a not found response when the service is deleted", authorized: true do
          @review.reviewable.discard
          get :index, params: { service_id: @review.reviewable_id }

          expect(response).to be_not_found
        end

        it "returns a not found response when the company is deleted", authorized: true do
          @review.reviewable.discard
          get :index, params: { service_id: @review.reviewable_id }
          expect(response).to be_not_found
        end

        it "does not return deleted reviews", authorized: true do
          @review.discard
          get :index, params: { service_id: @review.reviewable.hashid }

          expect(parsed_response).to match([])
          expect(response).to be_success
        end
      end
    end

    describe "GET #company_reviews" do
      let(:company) { create(:company) }
      it "returns a success response", authorized: true do
        get :company_reviews, params: { company_id: company.hashid }
        expect(response).to be_success
      end

      it "returns not found if company is not found", authorized: true do
        get :company_reviews, params: { company_id: 0 }
        expect(response.status).to eq(404)
      end

      it "returns not found if company is deleted", authorized: true do
        company.discard
        get :company_reviews, params: { company_id: company.id }
        expect(response.status).to eq(404)
      end

      it "accepts valid sort by", authorized: true do
        product = company.products.create! build(:product).attributes
        product.reviews.create! build(:product_review, vendor_id: company.id).attributes
        service = company.services.create! build(:service).attributes
        service.reviews.create! build(:service_review, vendor_id: company.id).attributes
        project = company.projects.create! build(:project).attributes
        latest_review = project.reviews.create! build(:project_review, vendor_id: company.id).attributes

        get :company_reviews, params: { company_id: company.hashid, sort_by: "created_at" }
        expect(response).to be_success
        expect(parsed_response.length).to eq(3)
        expect(parsed_response.first["content"]).to eq(latest_review.content)
      end

      it "disregards invalid sort by", authorized: true do
        product = company.products.create! build(:product).attributes
        product.reviews.create! build(:product_review, vendor_id: company.id).attributes
        service = company.services.create! build(:service).attributes
        service.reviews.create! build(:service_review, vendor_id: company.id).attributes
        project = company.projects.create! build(:project).attributes
        project.reviews.create! build(:project_review, vendor_id: company.id).attributes

        get :company_reviews, params: { company_id: company.hashid, sort_by: "aggregdsfate_score" }
        expect(response).to be_success
        expect(parsed_response.length).to eq(3)
      end

      it "respects per_page", authorized: true do
        product = company.products.create! build(:product).attributes
        product.reviews.create! build(:product_review, vendor_id: company.id).attributes
        service = company.services.create! build(:service).attributes
        service.reviews.create! build(:service_review, vendor_id: company.id).attributes
        project = company.projects.create! build(:project).attributes
        project.reviews.create! build(:project_review, vendor_id: company.id).attributes

        get :company_reviews, params: { company_id: company.hashid, sort_by: "aggregdsfate_score", per_page: 2 }
        expect(response).to be_success
        expect(parsed_response.length).to eq(2)
      end

      it "filters by positive", authorized: true do
        product = company.products.create! build(:product).attributes
        positive_review = product.reviews.create! build(:product_review, score: Review::POSITIVE, vendor_id: company.id).attributes
        service = company.services.create! build(:service).attributes
        service.reviews.create! build(:service_review, score: Review::NEUTRAL, vendor_id: company.id).attributes
        project = company.projects.create! build(:project).attributes
        project.reviews.create! build(:project_review, score: Review::NEGATIVE, vendor_id: company.id).attributes

        get :company_reviews, params: { company_id: company.hashid, filter_by_score: "POSITIVE", sort_by: "aggregdsfate_score", per_page: 2 }

        expect(response).to be_success
        expect(parsed_response.length).to eq(1)
        expect(parsed_response.first["content"]).to eq(positive_review.content)
      end

      it "filters by neutral", authorized: true do
        product = company.products.create! build(:product).attributes
        product.reviews.create! build(:product_review, score: Review::POSITIVE, vendor_id: company.id).attributes
        service = company.services.create! build(:service).attributes
        neutral_review = service.reviews.create! build(:service_review, score: Review::NEUTRAL, vendor_id: company.id).attributes
        project = company.projects.create! build(:project).attributes
        project.reviews.create! build(:project_review, score: Review::NEGATIVE, vendor_id: company.id).attributes

        get :company_reviews, params: { company_id: company.hashid, filter_by_score: "NEUTRAL", sort_by: "aggregdsfate_score", per_page: 2 }
        expect(response).to be_success
        expect(parsed_response.length).to eq(1)
        expect(parsed_response.first["content"]).to eq(neutral_review.content)
      end

      it "filters by negative", authorized: true do
        product = company.products.create! build(:product).attributes
        product.reviews.create! build(:product_review, score: Review::POSITIVE, vendor_id: company.id).attributes
        service = company.services.create! build(:service).attributes
        service.reviews.create! build(:service_review, score: Review::NEUTRAL, vendor_id: company.id).attributes
        project = company.projects.create! build(:project).attributes
        negative_review = project.reviews.create! build(:project_review, score: Review::NEGATIVE, vendor_id: company.id).attributes

        get :company_reviews, params: { company_id: company.hashid, filter_by_score: "NEGATIVE", sort_by: "aggregdsfate_score", per_page: 2 }
        expect(response).to be_success
        expect(parsed_response.length).to eq(1)
        expect(parsed_response.first["content"]).to eq(negative_review.content)
      end

      it "returns review counts if specified", authorized: true do
        product = company.products.create! build(:product).attributes
        product.reviews.create! build(:product_review, score: Review::POSITIVE, vendor_id: company.id).attributes
        service = company.services.create! build(:service).attributes
        service.reviews.create! build(:service_review, score: Review::NEUTRAL, vendor_id: company.id).attributes
        project = company.projects.create! build(:project).attributes
        negative_review = project.reviews.create! build(:project_review, score: Review::NEGATIVE, vendor_id: company.id).attributes

        get :company_reviews, params: { company_id: company.hashid, count: "true", filter_by_score: "NEGATIVE", sort_by: "aggregdsfate_score", per_page: 2 }
        expect(response).to be_success
        expect(parsed_response[:reviews].first[:content]).to eq(negative_review.content)
        expect(parsed_response[:reviews].first[:created_at]).not_to eq(nil)
        expect(parsed_response["positive_count"]).to eq(1)
        expect(parsed_response["neutral_count"]).to eq(1)
        expect(parsed_response["negative_count"]).to eq(1)
        expect(response.headers["Total"]).to eq(3)
      end
    end

    describe "GET #show" do
      before(:each) do
        @review = create(:product_review)
        @product = @review.reviewable
        @product.companies.create(build(:company_as_params))
      end
      it "returns a success response", authorized: true do
        get :show, params: { id: @review.to_param }
        expect(response).to be_success
      end

      it "returns not found when review not found", authorized: true do
        get :show, params: { id: 0 }
        expect(response).to be_not_found
      end

      it "returns a not found when the review is deleted", authorized: true do
        @review.discard
        get :show, params: { id: @review.to_param }
        expect(response).to be_not_found
      end

      it "returns a not found when the reviewable is deleted", authorized: true do
        @review.reviewable.discard
        get :show, params: { id: @review.to_param }
        expect(response).to be_not_found
      end

      it "returns a not found when the company is deleted", authorized: true do
        @review.reviewable.companies.first.discard
        get :show, params: { id: @review.to_param }
        expect(response).to be_not_found
      end

      it "returns a not found when the grant is deleted", authorized: true do
        @review.grant.discard
        get :show, params: { id: @review.to_param }
        expect(response).to be_not_found
      end

      it "returns a not found when the reviewer is deleted", authorized: true do
        @review.reviewer.discard
        get :show, params: { id: @review.to_param }
        expect(response).to be_not_found
      end
    end

    describe "POST #create" do
      context "product review" do
        before(:each) do
          @review = create(:product_review)
          @product = @review.reviewable
          @product.companies.create(build(:company_as_params))
        end
        context "with valid params" do
          it "creates a new Review", authorized: true do
            expect do
              post :create, params: { review: create_update_product_review, product_id: @product.hashid }
            end.to change(Review, :count).by(1)
          end

          it "renders a JSON response with the new review", authorized: true do
            post :create, params: { review: create_update_product_review, product_id: @product.hashid }
            expect(response).to have_http_status(:created)
            expect(response.content_type).to eq('application/json')
            expect(response.location).to eq(review_url(Review.last))
          end

          it "return 404 when grant id is not found", authorized: true do
            create_update_product_review["grant_id"] = 0
            post :create, params: { review: create_update_product_review, product_id: @product.hashid }
            expect(response).to have_http_status(404)
            expect(response.content_type).to eq('application/json')
          end

          it "return 404 when from id is not found", authorized: true do
            create_update_product_review["from_id"] = 0
            post :create, params: { review: create_update_product_review, product_id: @product.hashid }
            expect(response).to have_http_status(404)
            expect(response.content_type).to eq('application/json')
          end

          it "return 422 when from type is not subclass of reviewer", authorized: true do
            create_update_product_review["from_type"] = "agency"
            post :create, params: { review: create_update_product_review, product_id: @product.hashid }
            expect(response).to have_http_status(422)
            expect(response.content_type).to eq('application/json')
          end
        end

        context "with deleted product" do
          it "does not creates a new Review", authorized: true do
            @product.discard
            expect do
              post :create, params: { review: create_update_product_review, product_id: @product.hashid }
            end.to change(Review, :count).by(0)
          end

          it "renders a not found response", authorized: true do
            @product.discard
            post :create, params: { review: create_update_product_review, product_id: @product.hashid }
            expect(response).to have_http_status(404)
            expect(response.content_type).to eq('application/json')
          end
        end

        context "with deleted company" do
          it "does not creates a new Review", authorized: true do
            Company.find_by_hashid(create_update_product_review["vendor_id"]).discard
            expect do
              post :create, params: { review: create_update_product_review, product_id: @product.hashid }
            end.to change(Review, :count).by(0)
          end

          it "renders a not found response", authorized: true do
            Company.find_by_hashid(create_update_product_review["vendor_id"]).discard
            post :create, params: { review: create_update_product_review, product_id: @product.hashid }

            expect(response).to have_http_status(404)
            expect(response.content_type).to eq('application/json')
          end
        end

        context "with deleted grant" do
          it "does not creates a new Review", authorized: true do
            review = Review.create! valid_product_review
            review.grant.discard
            expect do
              create_update_product_review["grant_id"] = review.grant.id
              post :create, params: { review: create_update_product_review, product_id: @product.hashid }
            end.to change(Review, :count).by(0)
          end

          it "renders a not found response", authorized: true do
            review = Review.create! valid_product_review
            review.grant.discard
            create_update_product_review["grant_id"] = review.grant.id
            post :create, params: { review: create_update_product_review, product_id: @product.hashid }
            expect(response).to have_http_status(404)
            expect(response.content_type).to eq('application/json')
          end
        end

        context "with deleted reviewer" do
          it "does not creates a new Review", authorized: true do
            review = Review.create! valid_product_review
            review.reviewer.discard
            expect do
              create_update_product_review["from_id"] = review.reviewer.id
              post :create, params: { review: create_update_product_review, product_id: @product.hashid }
            end.to change(Review, :count).by(0)
          end

          it "renders a not found response", authorized: true do
            review = Review.create! valid_product_review
            review.reviewer.discard
            create_update_product_review["from_id"] = review.reviewer.id
            post :create, params: { review: create_update_product_review, product_id: @product.hashid }
            expect(response).to have_http_status(404)
            expect(response.content_type).to eq('application/json')
          end
        end

        context "with invalid params", authorized: true do
          it "renders a JSON response with errors for the new review" do
            post :create, params: { review: invalid_product_review, product_id: @product.hashid }
            expect(response).to have_http_status(400)
            expect(response.content_type).to eq('application/json')
          end
        end

        context "with non existent reviewable id", authorized: true do
          it "renders a JSON response with errors for the new review" do
            post :create, params: { review: create_update_product_review, product_id: 0 }
            expect(response).to be_not_found
            expect(response.content_type).to eq('application/json')
          end
        end
      end

      context "service review" do
        before(:each) do
          @review = create(:service_review)
          @service = @review.reviewable
          @service.companies.create(build(:company_as_params))
        end
        context "with valid params" do
          it "creates a new Review", authorized: true do
            expect do
              post :create, params: { review: create_update_service_review, service_id: @service.hashid }
            end.to change(Review, :count).by(1)
          end

          it "renders a JSON response with the new review", authorized: true do
            post :create, params: { review: create_update_service_review, service_id: @service.hashid }
            expect(response).to have_http_status(:created)
            expect(response.content_type).to eq('application/json')
            expect(response.location).to eq(review_url(Review.last))
          end

          it "return 404 when grant id is not found", authorized: true do
            product = create(:product)
            create_update_service_review["grant_id"] = 0
            post :create, params: { review: create_update_service_review, product_id: product.hashid }
            expect(response).to have_http_status(404)
            expect(response.content_type).to eq('application/json')
          end

          it "return 404 when from id is not found", authorized: true do
            product = create(:product)
            create_update_service_review["from_id"] = 0
            post :create, params: { review: create_update_service_review, product_id: product.hashid }
            expect(response).to have_http_status(404)
            expect(response.content_type).to eq('application/json')
          end

          it "return 422 when from type is not subclass of reviewer", authorized: true do
            create_update_service_review["from_type"] = "agency"
            post :create, params: { review: create_update_service_review, service_id: @service.hashid }
            expect(response).to have_http_status(422)
            expect(response.content_type).to eq('application/json')
          end
        end

        context "with deleted service" do
          it "does not creates a new Review", authorized: true do
            service = create(:service)
            service.discard
            expect do
              post :create, params: { review: create_update_service_review, service_id: service.hashid }
            end.to change(Review, :count).by(0)
          end

          it "renders a not found response", authorized: true do
            service = create(:service)
            service.discard
            post :create, params: { review: create_update_service_review, service_id: service.hashid }
            expect(response).to have_http_status(404)
            expect(response.content_type).to eq('application/json')
          end
        end

        context "with deleted company" do
          it "does not creates a new Review", authorized: true do
            Company.find_by_hashid(create_update_service_review["vendor_id"]).discard
            expect do
              post :create, params: { review: create_update_service_review, service_id: @service.hashid }
            end.to change(Review, :count).by(0)
          end

          it "renders a not found response", authorized: true do
            Company.find_by_hashid(create_update_service_review["vendor_id"]).discard
            post :create, params: { review: create_update_service_review, service_id: @service.hashid }
            expect(response).to have_http_status(404)
            expect(response.content_type).to eq('application/json')
          end
        end

        context "with invalid params", authorized: true do
          it "renders a JSON response with errors for the new review" do
            service = create(:service)

            post :create, params: { review: invalid_service_review, service_id: service.hashid }
            expect(response).to have_http_status(400)
            expect(response.content_type).to eq('application/json')
          end
        end

        context "with non existent reviewable id", authorized: true do
          it "renders a JSON response with errors for the new review" do
            post :create, params: { review: create_update_service_review, service_id: 0 }
            expect(response).to be_not_found
            expect(response.content_type).to eq('application/json')
          end
        end
      end
    end

    describe "PUT #update" do
      let(:new_attributes) do
        attributes_for(:product_review)
      end
      before(:each) do
        @review = create(:product_review)
        @product = @review.reviewable
        @product.companies.create(build(:company_as_params))
      end
      context "with valid params" do
        it "updates the requested review", authorized: true do
          put :update, params: { id: @review.to_param, review: new_attributes }
          @review.reload

          expect(@review.score).to eq(new_attributes[:score])
          expect(@review.content).to eq(new_attributes[:content])
        end

        it "renders a JSON response with the review", authorized: true do
          put :update, params: { id: @review.to_param, review: create_update_product_review }

          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end

        it "return 404 when grant id is not found", authorized: true do
          create_update_product_review["grant_id"] = 0
          put :update, params: { id: @review.to_param, review: create_update_product_review }
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end

        it "return 404 when from id is not found", authorized: true do
          create_update_product_review["from_id"] = 0
          put :update, params: { id: @review.to_param, review: create_update_product_review }
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end

        it "return 422 when from type is not subclass of reviewer", authorized: true do
          create_update_product_review["from_type"] = "agency"
          put :update, params: { id: @review.to_param, review: create_update_product_review }
          expect(response).to have_http_status(422)
          expect(response.content_type).to eq('application/json')
        end
        it "return 422 when from type is missing", authorized: true do
          create_update_product_review.delete("from_type")
          put :update, params: { id: @review.to_param, review: create_update_product_review }
          expect(response).to have_http_status(422)
          expect(response.content_type).to eq('application/json')
        end

        it "return 422 when from id is missing", authorized: true do
          create_update_product_review.delete("from_id")
          put :update, params: { id: @review.to_param, review: create_update_product_review }
          expect(response).to have_http_status(422)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted review" do
        it "does not updates the requested review", authorized: true do
          original_review = @review
          @review.discard
          put :update, params: { id: @review.to_param, review: new_attributes }
          @review.reload
          expect(@review.score).to eq(original_review[:score])
          expect(@review.content).to eq(original_review[:content])
        end

        it "renders a not found response", authorized: true do
          @review.discard
          put :update, params: { id: @review.to_param, review: new_attributes }
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted reviewable" do
        it "does not updates the requested review", authorized: true do
          original_review = @review
          @review.reviewable.discard
          put :update, params: { id: @review.to_param, review: new_attributes }
          @review.reload
          expect(@review.score).to eq(original_review[:score])
          expect(@review.content).to eq(original_review[:content])
        end

        it "renders a not found response", authorized: true do
          @review.reviewable.discard
          put :update, params: { id: @review.to_param, review: new_attributes }
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted company" do
        it "does not updates the requested review", authorized: true do
          original_review = @review
          @review.reviewable.companies.first.discard
          put :update, params: { id: @review.to_param, review: new_attributes }
          @review.reload
          expect(@review.score).to eq(original_review[:score])
          expect(@review.content).to eq(original_review[:content])
        end

        it "renders a not found response", authorized: true do
          @review.reviewable.companies.first.discard
          put :update, params: { id: @review.to_param, review: new_attributes }
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted grant" do
        it "does not updates the requested review", authorized: true do
          original_review = @review
          @review.grant.discard
          put :update, params: { id: @review.to_param, review: new_attributes }
          @review.reload
          expect(@review.score).to eq(original_review[:score])
          expect(@review.content).to eq(original_review[:content])
        end

        it "renders a not found response", authorized: true do
          @review.grant.discard
          put :update, params: { id: @review.to_param, review: new_attributes }
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted reviewer" do
        it "does not updates the requested review", authorized: true do
          original_review = @review
          @review.reviewer.discard
          put :update, params: { id: @review.to_param, review: new_attributes }
          @review.reload
          expect(@review.score).to eq(original_review[:score])
          expect(@review.content).to eq(original_review[:content])
        end

        it "renders a not found response", authorized: true do
          @review.reviewer.discard
          put :update, params: { id: @review.to_param, review: new_attributes }
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the review", authorized: true do
          put :update, params: { id: @review.to_param, review: invalid_product_review }
          expect(response).to have_http_status(422)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with non existent review id", authorized: true do
        it "renders a not found JSON response" do
          put :update, params: { id: 0, review: new_attributes }
          expect(response).to be_not_found
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "DELETE #destroy" do
      before(:each) do
        @review = create(:product_review)
        @product = @review.reviewable
        @product.companies.create(build(:company_as_params))
      end
      it "soft deletes", authorized: true do
        expect do
          delete :destroy, params: { id: @review.to_param }
        end.to change(Review, :count).by(0)
      end

      it "sets discarded_at datetime", authorized: true do
        delete :destroy, params: { id: @review.to_param }
        @review.reload
        expect(@review.discarded?).to be true
      end

      it "renders a JSON response with the review", authorized: true do
        delete :destroy, params: { id: @review.to_param }
        expect(response).to have_http_status(204)
      end

      it "returns a not found response when review deleted", authorized: true do
        @review.discard
        delete :destroy, params: { id: @review.id }
        expect(response).to be_not_found
      end

      it "returns a not found response when reviewable deleted", authorized: true do
        @review.reviewable.discard
        delete :destroy, params: { id: @review.id }
        expect(response).to be_not_found
      end

      it "returns a not found response when company deleted", authorized: true do
        @review.reviewable.companies.first.discard
        delete :destroy, params: { id: @review.id }
        expect(response).to be_not_found
      end

      it "returns a not found response when review not found", authorized: true do
        delete :destroy, params: { id: 0 }
        expect(response).to be_not_found
      end
    end
  end

  describe "Unauthorised user" do
    before(:each) do
      @review = create(:product_review)
      @product = @review.reviewable
      @product.companies.create(build(:company_as_params))
    end
    describe "GET #index" do
      it "returns an unauthorized response", authorized: false do
        review = Review.create! valid_product_review
        get :index, params: { product_id: review.reviewable_id }

        expect_unauthorized
      end
    end

    describe "GET #show" do
      it "returns an unauthorized response", authorized: false do
        review = Review.create! valid_product_review
        get :show, params: { id: review.to_param }

        expect_unauthorized
      end
    end

    describe "POST #create" do
      it "does not create a new Review", authorized: false do
        expect do
          post :create, params: { review: valid_product_review, product_id: @product.hashid }
        end.to change(Review, :count).by(0)
      end

      it "returns an unauthorized response", authorized: false do
        post :create, params: { review: valid_product_review, product_id: @product.hashid }
        expect_unauthorized
      end
    end

    describe "PUT #update" do
      let(:new_attributes) do
        attributes_for(:service_review)
      end

      it "does not update the requested review", authorized: false do
        current_attributes = @review.attributes

        put :update, params: { id: @review.to_param, review: new_attributes }
        @review.reload
        expect(@review.score).to eq(current_attributes["score"])
        expect(@review.content).to eq(current_attributes["content"])
        expect(@review.reviewable_id).to eq(current_attributes["reviewable_id"])
        expect(@review.reviewable_type).to eq(current_attributes["reviewable_type"])
      end

      it "returns an unauthorized response", authorized: false do
        put :update, params: { id: @review.to_param, review: valid_product_review }
        expect_unauthorized
      end
    end

    describe "DELETE #destroy" do
      it "does not destroy the requested review", authorized: false do
        expect do
          delete :destroy, params: { id: @review.to_param }
        end.to change(Review, :count).by(0)
      end

      it "does not destroy the requested review", authorized: false do
        expect do
          delete :destroy, params: { id: @review.to_param }
        end.to change(Review, :count).by(0)
      end

      it "does not set discarded_at datetime", authorized: false do
        delete :destroy, params: { id: @review.to_param }
        @review.reload
        expect(@review.discarded?).to be false
      end

      it "returns an unauthorized response", authorized: false do
        delete :destroy, params: { id: @review.to_param }
        expect_unauthorized
      end
    end
  end
end