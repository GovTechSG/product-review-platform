require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Products", type: :request do
  let(:valid_attributes) do
    build(:product).attributes
  end

  let(:invalid_attributes) do
    build(:product, name: nil).attributes
  end

  describe "Authorised user" do
    describe "GET #index" do
      it "returns a success response" do
        product = Product.create! valid_attributes
        get company_products_path(product.company.id), headers: request_login

        expect(response).to be_success
      end
    end

    describe "GET #show" do
      it "returns a success response" do
        product = Product.create! valid_attributes
        get product_path(product.id), headers: request_login
        expect(response).to be_success
      end

      it "returns not found when product not found" do
        get product_path(0), headers: request_login
        expect(response).to be_not_found
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Product" do
          company = create(:company)

          expect do
            post company_products_path(company.id), params: { product: valid_attributes }, headers: request_login
          end.to change(Product, :count).by(1)
        end

        it "renders a JSON response with the new product" do
          company = create(:company)

          post company_products_path(company.id), params: { product: valid_attributes }, headers: request_login
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(product_url(Product.last))
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the new product" do
          company = create(:company)

          post company_products_path(company.id), params: { product: invalid_attributes }, headers: request_login
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

        it "updates the requested product" do
          product = Product.create! valid_attributes

          put product_path(product), params: { product: new_attributes }, headers: request_login
          product.reload
          expect(product.name).to eq(new_attributes[:name])
          expect(product.description).to eq(new_attributes[:description])
        end

        it "renders a JSON response with the product" do
          product = Product.create! valid_attributes

          put product_path(product), params: { product: new_attributes }, headers: request_login
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the product" do
          product = Product.create! valid_attributes

          put product_path(product), params: { product: invalid_attributes }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "DELETE #destroy" do
      it "soft deletes" do
        product = Product.create! valid_attributes
        expect do
          delete product_path(product.id), params: {}, headers: request_login
        end.to change(Product, :count).by(0)
      end

      it "sets discarded_at datetime" do
        product = Product.create! valid_attributes
        delete product_path(product.id), params: {}, headers: request_login
        product.reload
        expect(product.discarded?).to be true
      end

      it "renders a JSON response with the product" do
        product = Product.create! valid_attributes

        delete product_path(product.id), params: {}, headers: request_login
        expect(response).to have_http_status(204)
      end

      it "returns a not found response when product not found" do
        delete product_path(0), params: {}, headers: request_login
        expect(response).to be_not_found
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET #index" do
      it "returns an unauthorized response" do
        product = Product.create! valid_attributes
        get company_products_path(product.company.id), headers: nil

        expect_unauthorized
      end
    end

    describe "GET #show" do
      it "returns an unauthorized response" do
        product = Product.create! valid_attributes
        get product_path(product.id), headers: nil

        expect_unauthorized
      end
    end

    describe "POST #create" do
      it "does not create a new Product" do
        company = create(:company)

        expect do
          post company_products_path(company.id), params: { product: valid_attributes }, headers: nil
        end.to change(Product, :count).by(0)
      end

      it "returns an unauthorized response" do
        company = create(:company)

        post company_products_path(company.id), params: { product: valid_attributes }, headers: nil
        expect_unauthorized
      end
    end

    describe "PUT #update" do
      let(:new_attributes) do
        attributes_for(:product)
      end

      it "does not update the requested product" do
        product = Product.create! valid_attributes
        current_attributes = product.attributes

        put product_path(product), params: { product: new_attributes }, headers: nil
        product.reload
        expect(product.name).to eq(current_attributes["name"])
        expect(product.description).to eq(current_attributes["description"])
      end

      it "returns an unauthorized response" do
        product = Product.create! valid_attributes

        put product_path(product), params: { product: new_attributes }, headers: nil
        expect_unauthorized
      end
    end

    describe "DELETE #destroy" do
      it "does not destroy the requested product" do
        product = Product.create! valid_attributes
        expect do
          delete product_path(product.id), params: {}, headers: nil
        end.to change(Product, :count).by(0)
      end

      it "does not set discarded_at datetime" do
        product = Product.create! valid_attributes
        delete product_path(product.id), params: {}, headers: nil
        product.reload
        expect(product.discarded?).to be false
      end

      it "returns an unauthorized response" do
        product = Product.create! valid_attributes

        delete product_path(product.id), params: {}, headers: nil
        expect_unauthorized
      end
    end
  end
end