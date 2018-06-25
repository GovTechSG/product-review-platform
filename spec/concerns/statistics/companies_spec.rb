require 'rails_helper'

shared_examples_for 'companies' do
  let(:valid_product) do
    build(:product).attributes
  end
  let(:valid_service) do
    build(:service).attributes
  end
  let(:valid_product_review) do
    build(:product_review).attributes
  end
  let(:valid_service_review) do
    build(:service_review).attributes
  end
  let(:valid_company) do
    create(:company, aggregate_score: 0)
  end

  describe "reviews_count" do
    context "no product and service" do
      it "returns 0" do
        expect(valid_company.reviews_count).to eq(0)
      end
    end

    context "does not count discarded products and services" do
      it "returns 0" do
        service = valid_company.services.create! valid_service
        service.reviews.create! valid_service_review
        service.reviews.create! valid_service_review
        service.discard
        product = valid_company.products.create! valid_product
        product.reviews.create! valid_product_review
        product.reviews.create! valid_product_review
        product.discard
        valid_company.reload
        expect(valid_company.reviews_count).to eq(0)
      end
    end

    context "does not count discarded reviews" do
      it "returns 0" do
        service = valid_company.services.create! valid_service
        service.reviews.create! valid_service_review
        service.reviews.create! valid_service_review
        service.reviews.first.discard
        product = valid_company.products.create! valid_product
        product.reviews.create! valid_product_review
        product.reviews.create! valid_product_review
        product.reviews.first.discard
        valid_company.reload
        expect(valid_company.reviews_count).to eq(2)
      end
    end

    context "no product" do
      it "returns service count" do
        service = valid_company.services.create! valid_service
        service.reviews.create! valid_service_review
        service.reviews.create! valid_service_review
        valid_company.reload
        expect(valid_company.reviews_count).to eq(2)
      end
    end

    context "no service" do
      it "returns product count" do
        product = valid_company.products.create! valid_product
        product.reviews.create! valid_product_review
        product.reviews.create! valid_product_review
        valid_company.reload
        expect(valid_company.reviews_count).to eq(2)
      end
    end

    context "product and service" do
      it "returns review count" do
        service = valid_company.services.create! valid_service
        service.reviews.create! valid_service_review
        service.reviews.create! valid_service_review
        product = valid_company.products.create! valid_product
        product.reviews.create! valid_product_review
        product.reviews.create! valid_product_review
        valid_company.reload
        expect(valid_company.reviews_count).to eq(4)
      end
    end
  end

  describe "aspects" do
    context "no product and service" do
      it "returns empty array" do
        expect(valid_company.aspects).to eq([])
      end
    end

    context "no product" do
      it "returns service aspect" do
        service = valid_company.services.create! valid_service
        review = service.reviews.create! valid_service_review

        expect(valid_company.aspects).to eq(review.aspects)
      end
    end

    context "no service" do
      it "returns product aspect" do
        product = valid_company.products.create! valid_product
        review = product.reviews.create! valid_product_review
        expect(valid_company.aspects).to eq(review.aspects)
      end
    end

    context "does not add discarded products and services" do
      it "returns 0" do
        service = valid_company.services.create! valid_service
        service.reviews.create! valid_service_review
        product = valid_company.products.create! valid_product
        product.reviews.create! valid_product_review
        service.discard
        product.discard
        expect(valid_company.aspects).to eq([])
      end
    end

    context "does not count discarded reviews" do
      it "returns 0" do
        service = valid_company.services.create! valid_service
        service.reviews.create! valid_service_review
        product = valid_company.products.create! valid_product
        product.reviews.create! valid_product_review
        service.reviews.first.discard
        product.reviews.first.discard

        expect(valid_company.aspects).to eq([])
      end
    end

    context "product and service" do
      it "returns review aspects" do
        service = valid_company.services.create! valid_service
        service_review = service.reviews.create! valid_service_review
        product = valid_company.products.create! valid_product
        product_review = product.reviews.create! valid_product_review
        expect(valid_company.aspects).to eq((product_review.aspects + service_review.aspects)[0..5])
      end
    end
  end

end
