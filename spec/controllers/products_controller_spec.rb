require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe ProductsController, type: :controller do
  let(:valid_attributes) do
    build(:product).attributes
  end

  let(:invalid_attributes) do
    build(:product, name: nil).attributes
  end

  let(:valid_session) {}

  let(:token) { double acceptable?: true }

  before(:each, authorized: true) do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  before(:each) do
    @product = create(:product)
    @product.companies.create!(build(:company_as_params))
  end

  describe "Authorised user" do
    describe "GET #index" do
      it "returns a success response", authorized: true do
        get :index, params: { company_id: @product.companies.first.hashid }

        expect(response).to be_success
      end

      it "returns 25 result (1 page)", authorized: true do
        default_result_per_page = 25
        num_of_object_to_create = 30
        company = Company.create! build(:company).attributes

        while num_of_object_to_create > 0
          product = create(:product)
          CompanyReviewable.create!(company: company, reviewable: product)

          num_of_object_to_create -= 1
        end

        get :index, params: { company_id: company.hashid }
        expect(JSON.parse(response.body).count).to match default_result_per_page
      end

      it "does not return deleted products", authorized: true do
        @product.discard
        get :index, params: { company_id: @product.companies.first.hashid }
        expect(parsed_response).to match([])
        expect(response).to be_success
      end

      it "returns not found when the product's company is deleted", authorized: true do
        @product.companies.first.discard
        get :index, params: { company_id: @product.companies.first.hashid }

        expect(response).to be_not_found
      end

      it "returns not found when product's company ID not found", authorized: true do
        get :index, params: { company_id: 0 }
        expect(response).to be_not_found
      end
    end

    describe "GET #show" do
      it "returns a success response", authorized: true do
        get :show, params: { id: @product.to_param }
        expect(response).to be_success
      end

      it "returns a not found when the product is deleted", authorized: true do
        @product.discard
        get :show, params: { id: @product.to_param }
        expect(response).to be_not_found
      end

      it "returns a not found when all company is discarded", authorized: true do
        @product.companies.first.discard
        get :show, params: { id: @product.to_param }
        expect(response).to be_not_found
      end

      it "returns success when at least one company is not discarded", authorized: true do
        @product.companies.create!(build(:company_as_params))
        @product.companies.first.discard
        get :show, params: { id: @product.to_param }
        expect(response).to be_success
      end

      it "returns not found when product not found", authorized: true do
        get :show, params: { id: 0 }
        expect(response).to be_not_found
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Product", authorized: true do
          company = create(:company)

          expect do
            post :create, params: { product: valid_attributes, company_id: company.hashid }
          end.to change(Product, :count).by(1)
        end

        it "renders a JSON response with the new product", authorized: true do
          company = create(:company)

          post :create, params: { product: valid_attributes, company_id: company.hashid }
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(product_url(Product.last))
        end

        it "returns not found when product's company ID not found", authorized: true do
          post :create, params: { product: valid_attributes, company_id: 0 }
          expect(response).to be_not_found
        end

        it "renders not found when the product's company is deleted", authorized: true do
          company = create(:company)
          company.discard
          post :create, params: { product: valid_attributes, company_id: company.id }
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
        it "does not create when the product's company is deleted", authorized: true do
          company = create(:company)
          company.discard
          expect do
            post :create, params: { product: valid_attributes, company_id: company.id }
          end.to change(Product, :count).by(0)
        end
      end

      context "with invalid params", authorized: true do
        it "renders a JSON response with errors for the new product" do
          company = create(:company)

          post :create, params: { product: invalid_attributes, company_id: company.hashid }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) do
          attributes_for(:product)
        end

        it "updates the requested product", authorized: true do
          put :update, params: { id: @product.to_param, product: new_attributes }, session: valid_session
          @product.reload
          expect(@product.name).to eq(new_attributes[:name])
          expect(@product.description).to eq(new_attributes[:description])
        end

        it "renders a JSON response with the product", authorized: true do
          put :update, params: { id: @product.to_param, product: valid_attributes }, session: valid_session
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end

        it "returns not found when product ID not found", authorized: true do
          put :update, params: { id: 0, product: valid_attributes }, session: valid_session
          expect(response).to be_not_found
        end

        it "renders not found when product is deleted", authorized: true do
          @product.discard
          put :update, params: { id: @product.to_param, product: valid_attributes }, session: valid_session
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end

        it "does not update when product is deleted", authorized: true do
          original_attributes = @product
          @product.discard
          put :update, params: { id: @product.to_param, product: valid_attributes }, session: valid_session
          @product.reload
          expect(@product.name).to eq(original_attributes[:name])
          expect(@product.description).to eq(original_attributes[:description])
        end

        it "renders not found when company is deleted", authorized: true do
          @product.companies.first.discard
          put :update, params: { id: @product.to_param, product: valid_attributes }, session: valid_session
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end

        it "does not update when company is deleted", authorized: true do
          original_attributes = @product
          @product.companies.first.discard
          put :update, params: { id: @product.to_param, product: valid_attributes }, session: valid_session
          @product.reload
          expect(@product.name).to eq(original_attributes[:name])
          expect(@product.description).to eq(original_attributes[:description])
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the product", authorized: true do
          put :update, params: { id: @product.to_param, product: invalid_attributes }, session: valid_session
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "DELETE #destroy" do
      it "soft deletes", authorized: true do
        expect do
          delete :destroy, params: { id: @product.to_param }, session: valid_session
        end.to change(Product, :count).by(0)
      end

      it "sets discarded_at datetime", authorized: true do
        delete :destroy, params: { id: @product.to_param }
        @product.reload
        expect(@product.discarded?).to be true
      end

      it "renders a JSON response with the product", authorized: true do
        delete :destroy, params: { id: @product.to_param }
        expect(response).to have_http_status(204)
      end

      it "renders a not found if the product is deleted", authorized: true do
        @product.discard
        delete :destroy, params: { id: @product.to_param }
        expect(response).to have_http_status(404)
      end

      it "renders a not found if the company is deleted", authorized: true do
        @product.companies.first.discard
        delete :destroy, params: { id: @product.to_param }
        expect(response).to have_http_status(404)
      end

      it "returns a not found response when product not found", authorized: true do
        delete :destroy, params: { id: 0 }
        expect(response).to be_not_found
      end
    end

    describe "POST #search", authorized: true do
      it "returns a success response when product is found" do
        post :search, params: { product_name: @product.name, company: { uen: 999, name: 'test', description: 'for test' }, vendor_name: @product.companies.first.name, vendor_uen: @product.companies.first.uen }
        expect(response).to be_success
      end

      it "creates product if product is not found" do
        expect do
          post :search, params: { product_name: "new product", product: { description: '' }, company: { uen: 999, name: 'test', description: 'for test' }, vendor_name: "new vendor", vendor_uen: 123 }
        end.to change { Product.count }.by(1)
      end

      it "does not create product if product is found" do
        post :search, params: { product_name: "new product", product: { description: '' }, company: { uen: 999, name: 'test', description: 'for test' }, vendor_name: "new vendor", vendor_uen: 123 }
        expect do
          post :search, params: { product_name: "new product", product: { description: '' }, company: { uen: 999, name: 'test', description: 'for test' }, vendor_name: "new vendor", vendor_uen: 123 }
        end.to change { Product.count }.by(0)
      end

      it "creates vendor if vendor is not found" do
        company = create(:company)
        expect do
          post :search, params: { product_name: "new product", product: { description: '' }, company: { uen: company.uen, name: company.name, description: company.description }, vendor_name: "new vendor", vendor_uen: 123 }
        end.to change { Company.count }.by(1)
      end

      it "does not create vendor or reviewer if vendor is found" do
        company = create(:company)
        product = create(:product)
        CompanyReviewable.create(company: company, reviewable: product)
        expect do
          post :search, params: { product_name: product.name, product: { description: product.description }, company: { uen: company.uen, name: company.name, description: company.description }, vendor_name: product.companies.first.name, vendor_uen: product.companies.first.uen }
        end.to change { Company.count }.by(0)
      end

      it "creates reviewer if reviewer is not found" do
        company = create(:company)
        product = create(:product)
        CompanyReviewable.create(company: company, reviewable: product)
        expect do
          post :search, params: { product_name: product.name, product: { description: product.description }, company: { uen: 123, name: "aname", description: "adesc" }, vendor_name: product.companies.first.name, vendor_uen: product.companies.first.uen }
        end.to change { Company.count }.by(1)
      end

      it "seaches by uen" do
        product = create(:product)
        reviewer = create(:company)
        CompanyReviewable.create(company: reviewer, reviewable: product)
        post :search, params: { product_name: product.name, product: { description: product.description }, company: { uen: reviewer.uen, name: "aname", description: "adesc" }, vendor_name: "wrong", vendor_uen: product.companies.first.uen }
        expect(response).to be_success
      end

      it "searches by name if uen is not found" do
        product = create(:product)
        reviewer = create(:company)
        CompanyReviewable.create(company: reviewer, reviewable: product)
        post :search, params: { product_name: product.name, product: { description: product.description }, company: { uen: 123, name: reviewer.name, description: "adesc" }, vendor_name: product.companies.first.name, vendor_uen: 321 }
        expect(response).to be_success
      end

      it "searches by name if uen is blank" do
        product = create(:product)
        reviewer = create(:company)
        CompanyReviewable.create(company: reviewer, reviewable: product)
        post :search, params: { product_name: product.name, product: { description: product.description }, company: { uen: "", name: reviewer.name, description: "adesc" }, vendor_name: product.companies.first.name, vendor_uen: "" }
        expect(response).to be_success
      end

      it "can submit multiple blanks" do
        product = build(:product)

        expect do
          expect do
            post :search, params: { product_name: product.name, product: { description: product.description }, company: { uen: "", name: "aname", description: "adesc" }, vendor_name: "bname", vendor_uen: "" }
            post :search, params: { product_name: product.name, product: { description: product.description }, company: { uen: "", name: "abname", description: "adesc" }, vendor_name: "vname", vendor_uen: "" }
          end.to change { Company.count }.by(4)
        end.to change { Product.count }.by(1)
      end

      it "returns a success response" do
        post :search, params: { product_name: 'test', product: { description: 'for test' }, company: { uen: 999, name: 'test', description: 'for test' }, vendor_name: "abc", vendor_uen: 123 }
        expect(response).to be_success
      end

      it "requires vendor name and uen" do
        post :search, params: { product_name: 'test', product: { description: 'for test' }, company: { uen: 999, name: 'test', description: 'for test' } }
        expect(response.status).to eq(404)
      end

      it "returns a unprocessable_entity response when company creation failed" do
        post :search, params: { product_name: 'test', company: { uen: 999, name: '', description: '' }, vendor_name: "abc", vendor_uen: 123 }
        expect(response.status).to eq(422)
      end

      it "returns a company when company uen is found" do
        create(:company, uen: "999")
        post :search, params: { product_name: 'test', product: { description: 'test' }, company: { uen: 999, name: '', description: '' }, vendor_name: "abc", vendor_uen: 123 }
        expect(response).to be_success
      end

      it "returns a company when company uen is not found but name is found" do
        create(:company, name: "tEst name", uen: "999")
        post :search, params: { product_name: 'test', product: { description: 'test' }, company: { uen: 888, name: '  Test NaMe   ', description: '' }, vendor_name: "abc", vendor_uen: 123 }
        expect(response).to be_success
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET #index" do
      it "returns an unauthorized response", authorized: false do
        get :index, params: { company_id: @product.companies.first.hashid }

        expect_unauthorized
      end
    end

    describe "GET #show" do
      it "returns an unauthorized response", authorized: false do
        get :show, params: { id: @product.to_param }

        expect_unauthorized
      end
    end

    describe "POST #create" do
      it "does not create a new Product", authorized: false do
        company = create(:company)

        expect do
          post :create, params: { product: valid_attributes, company_id: company.id }
        end.to change(Product, :count).by(0)
      end

      it "returns an unauthorized response", authorized: false do
        company = create(:company)

        post :create, params: { product: valid_attributes, company_id: company.id }
        expect_unauthorized
      end
    end

    describe "PUT #update" do
      let(:new_attributes) do
        attributes_for(:product)
      end

      it "does not update the requested product", authorized: false do
        current_attributes = @product.attributes

        put :update, params: { id: @product.to_param, product: new_attributes }, session: valid_session
        @product.reload
        expect(@product.name).to eq(current_attributes["name"])
        expect(@product.description).to eq(current_attributes["description"])
      end

      it "returns an unauthorized response", authorized: false do
        put :update, params: { id: @product.to_param, product: valid_attributes }, session: valid_session
        expect_unauthorized
      end
    end

    describe "DELETE #destroy" do
      it "does not destroy the requested product", authorized: false do
        expect do
          delete :destroy, params: { id: @product.to_param }, session: valid_session
        end.to change(Product, :count).by(0)
      end

      it "does not set discarded_at datetime", authorized: false do
        delete :destroy, params: { id: @product.to_param }
        @product.reload
        expect(@product.discarded?).to be false
      end
      it "returns an unauthorized response", authorized: false do
        delete :destroy, params: { id: @product.to_param }, session: valid_session
        expect_unauthorized
      end
    end
  end
end
