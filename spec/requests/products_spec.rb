require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Products", type: :request do
  let(:valid_attributes) do
    build(:product).attributes
  end

  let(:invalid_attributes) do
    build(:product, name: nil).attributes
  end

  before(:each) do
    @company_reviewable = create(:company_product)
    @product = @company_reviewable.reviewable
    @company = @company_reviewable.company
    @review = @product.reviews.create!(build(:product_review, vendor_id: @company.id).attributes)
  end

  describe "Authorised user" do
    describe "GET /api/v1/companies/:company_id/products" do
      it "returns a success response" do
        get company_products_path(@company.hashid), headers: request_login

        expect(response).to be_success
      end

      it "returns not found if the company is deleted" do
        @company.discard
        get company_products_path(@company.hashid), headers: request_login

        expect(response).to be_not_found
      end

      it "returns not found if the company is not found" do
        get company_products_path(0), headers: request_login

        expect(response).to be_not_found
      end

      it "does not return deleted products" do
        @product.discard
        get company_products_path(@company.hashid), headers: request_login

        expect(response).to be_success
        expect(parsed_response).to match([])
      end
    end

    describe "GET /products/:id" do
      it "returns a success response" do
        get product_path(@product.hashid), headers: request_login
        expect(response).to be_success
      end

      it "returns not found when the product is deleted" do
        @product.discard
        get product_path(@product.hashid), headers: request_login
        expect(response).to be_not_found
      end

      it "returns not found when the company is deleted" do
        @company.discard
        get product_path(@product.hashid), headers: request_login
        expect(response).to be_not_found
      end

      it "returns not found when product not found" do
        get product_path(0), headers: request_login
        expect(response).to be_not_found
      end
    end

    describe "POST /api/v1/companies/:company_id/products" do
      context "with valid params" do
        it "creates a new Product" do
          expect do
            post company_products_path(@company.hashid), params: { product: valid_attributes }, headers: request_login
          end.to change(Product, :count).by(1)
        end

        it "renders a JSON response with the new product" do
          post company_products_path(@company.hashid), params: { product: valid_attributes }, headers: request_login
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(product_url(Product.last))
        end

        it "renders not found if the company is not found" do
          post company_products_path(0), params: { product: valid_attributes }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end

        it "renders not found if the company is deleted" do
          @company.discard

          post company_products_path(@company.hashid), params: { product: valid_attributes }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the new product" do
          post company_products_path(@company.hashid), params: { product: invalid_attributes }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "PUT /api/v1/products/:id" do
      context "with valid params" do
        let(:new_attributes) do
          attributes_for(:product)
        end

        it "updates the requested product" do
          put product_path(@product), params: { product: new_attributes }, headers: request_login
          @product.reload
          expect(@product.name).to eq(new_attributes[:name])
          expect(@product.description).to eq(new_attributes[:description])
        end

        it "renders a JSON response with the product" do
          put product_path(@product), params: { product: new_attributes }, headers: request_login
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end

        it "does not update the requested product when the company is deleted" do
          original_product = @product
          @company.discard
          put product_path(@product), params: { product: new_attributes }, headers: request_login
          @product.reload
          expect(@product.name).to eq(original_product[:name])
          expect(@product.description).to eq(original_product[:description])
        end

        it "does not update the requested product when the product is deleted" do
          original_product = @product
          @product.discard
          put product_path(@product), params: { product: new_attributes }, headers: request_login
          @product.reload
          expect(@product.name).to eq(original_product[:name])
          expect(@product.description).to eq(original_product[:description])
        end

        it "renders not found when the product is not found" do
          put product_path(0), params: { product: new_attributes }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end

        it "renders a JSON response with the product" do
          put product_path(@product), params: { product: new_attributes }, headers: request_login
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the product" do
          put product_path(@product), params: { product: invalid_attributes }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "DELETE /api/v1/products/:id" do
      it "soft deletes" do
        expect do
          delete product_path(@product.hashid), params: {}, headers: request_login
        end.to change(Product, :count).by(0)
      end

      it "sets discarded_at datetime" do
        delete product_path(@product.hashid), params: {}, headers: request_login
        @product.reload
        expect(@product.discarded?).to be true
      end

      it "renders a JSON response with the product" do
        delete product_path(@product.hashid), params: {}, headers: request_login
        expect(response).to have_http_status(204)
      end

      it "render not found when the product is deleted" do
        @product.discard
        delete product_path(@product.hashid), params: {}, headers: request_login
        expect(@response).to have_http_status(404)
      end

      it "render not found when the company is deleted" do
        @company.discard
        delete product_path(@product.hashid), params: {}, headers: request_login
        expect(response).to have_http_status(404)
      end

      it "returns a not found response when product not found" do
        delete product_path(0), params: {}, headers: request_login
        expect(response).to be_not_found
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET /api/v1/companies/:company_id/products" do
      it "returns an unauthorized response" do
        get company_products_path(@company.hashid), headers: nil

        expect_unauthorized
      end
    end

    describe "GET /products/:id" do
      it "returns an unauthorized response" do
        get product_path(@product.hashid), headers: nil

        expect_unauthorized
      end
    end

    describe "POST /api/v1/companies/:company_id/products" do
      it "does not create a new Product" do
        expect do
          post company_products_path(@company.hashid), params: { product: valid_attributes }, headers: nil
        end.to change(Product, :count).by(0)
      end

      it "returns an unauthorized response" do
        post company_products_path(@company.hashid), params: { product: valid_attributes }, headers: nil
        expect_unauthorized
      end
    end

    describe "PUT /products/:id" do
      let(:new_attributes) do
        attributes_for(:product)
      end

      it "does not update the requested product" do
        current_attributes = @product.attributes

        put product_path(@product), params: { product: new_attributes }, headers: nil
        @product.reload
        expect(@product.name).to eq(current_attributes["name"])
        expect(@product.description).to eq(current_attributes["description"])
      end

      it "returns an unauthorized response" do
        put product_path(@product), params: { product: new_attributes }, headers: nil
        expect_unauthorized
      end
    end

    describe "DELETE /api/v1/products/:id" do
      it "does not destroy the requested product" do
        expect do
          delete product_path(@product.hashid), params: {}, headers: nil
        end.to change(Product, :count).by(0)
      end

      it "does not set discarded_at datetime" do
        delete product_path(@product.hashid), params: {}, headers: nil
        @product.reload
        expect(@product.discarded?).to be false
      end

      it "returns an unauthorized response" do
        delete product_path(@product.hashid), params: {}, headers: nil
        expect_unauthorized
      end
    end
  end
end
