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

  describe "Authorised user" do
    describe "GET #index" do
      it "returns a success response", authorized: true do
        product = Product.create! valid_attributes
        get :index, params: { company_id: product.company.id }

        expect(response).to be_success
      end
    end

    describe "GET #show" do
      it "returns a success response", authorized: true do
        product = Product.create! valid_attributes
        get :show, params: { id: product.to_param }
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
            post :create, params: { product: valid_attributes, company_id: company.id }
          end.to change(Product, :count).by(1)
        end

        it "renders a JSON response with the new product", authorized: true do
          company = create(:company)

          post :create, params: { product: valid_attributes, company_id: company.id }
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(product_url(Product.last))
        end
      end

      context "with invalid params", authorized: true do
        it "renders a JSON response with errors for the new product" do
          company = create(:company)

          post :create, params: { product: invalid_attributes, company_id: company.id }
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
          product = Product.create! valid_attributes

          put :update, params: { id: product.to_param, product: new_attributes }, session: valid_session
          product.reload
          expect(product.name).to eq(new_attributes[:name])
          expect(product.description).to eq(new_attributes[:description])
        end

        it "renders a JSON response with the product", authorized: true do
          product = Product.create! valid_attributes

          put :update, params: { id: product.to_param, product: valid_attributes }, session: valid_session
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the product", authorized: true do
          product = Product.create! valid_attributes

          put :update, params: { id: product.to_param, product: invalid_attributes }, session: valid_session
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "DELETE #destroy" do
      it "soft deletes", authorized: true do
        product = Product.create! valid_attributes
        expect do
          delete :destroy, params: { id: product.to_param }, session: valid_session
        end.to change(Product, :count).by(0)
      end

      it "sets discarded_at datetime", authorized: true do
        product = Product.create! valid_attributes
        delete :destroy, params: { id: product.to_param }
        product.reload
        expect(product.discarded?).to be true
      end

      it "renders a JSON response with the product", authorized: true do
        product = Product.create! valid_attributes

        delete :destroy, params: { id: product.to_param }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end

      it "returns a not found response when product not found", authorized: true do
        delete :destroy, params: { id: 0 }
        expect(response).to be_not_found
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET #index" do
      it "returns an unauthorized response", authorized: false do
        product = Product.create! valid_attributes
        get :index, params: { company_id: product.company.id }

        expect_unauthorized
      end
    end

    describe "GET #show" do
      it "returns an unauthorized response", authorized: false do
        product = Product.create! valid_attributes
        get :show, params: { id: product.to_param }

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
        product = Product.create! valid_attributes
        current_attributes = product.attributes

        put :update, params: { id: product.to_param, product: new_attributes }, session: valid_session
        product.reload
        expect(product.name).to eq(current_attributes["name"])
        expect(product.description).to eq(current_attributes["description"])
      end

      it "returns an unauthorized response", authorized: false do
        product = Product.create! valid_attributes

        put :update, params: { id: product.to_param, product: valid_attributes }, session: valid_session
        expect_unauthorized
      end
    end

    describe "DELETE #destroy" do
      it "does not destroy the requested product", authorized: false do
        product = Product.create! valid_attributes
        expect do
          delete :destroy, params: { id: product.to_param }, session: valid_session
        end.to change(Product, :count).by(0)
      end

      it "does not set discarded_at datetime", authorized: false do
        product = Product.create! valid_attributes
        delete :destroy, params: { id: product.to_param }
        product.reload
        expect(product.discarded?).to be false
      end

      it "returns an unauthorized response", authorized: false do
        product = Product.create! valid_attributes

        delete :destroy, params: { id: product.to_param }, session: valid_session
        expect_unauthorized
      end
    end
  end
end
