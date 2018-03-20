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
    build(:company, aggregate_score: 0).attributes
  end

  describe "reviews_count" do
    context "no product and service" do
      it "returns 0" do
        company = Company.create! valid_company
        expect(company.reviews_count).to eq(0)
      end
    end

    context "does not count discarded products and services" do
      it "returns 0" do
        company = Company.create! valid_company
        service = company.services.create! valid_service
        service.reviews.create! valid_service_review
        service.reviews.create! valid_service_review
        service.discard
        product = company.products.create! valid_product
        product.reviews.create! valid_product_review
        product.reviews.create! valid_product_review
        product.discard
        expect(company.reviews_count).to eq(0)
      end
    end

    context "does not count discarded reviews" do
      it "returns 0" do
        company = Company.create! valid_company
        service = company.services.create! valid_service
        service.reviews.create! valid_service_review
        service.reviews.create! valid_service_review
        service.reviews.first.discard
        product = company.products.create! valid_product
        product.reviews.create! valid_product_review
        product.reviews.create! valid_product_review
        product.reviews.first.discard
        company.reload
        expect(company.reviews_count).to eq(2)
      end
    end

    context "no product" do
      it "returns service count" do
        company = Company.create! valid_company
        service = company.services.create! valid_service
        service.reviews.create! valid_service_review
        service.reviews.create! valid_service_review
        company.reload
        expect(company.reviews_count).to eq(2)
      end
    end

    context "no service" do
      it "returns product count" do
        company = Company.create! valid_company
        product = company.products.create! valid_product
        product.reviews.create! valid_product_review
        product.reviews.create! valid_product_review
        company.reload
        expect(company.reviews_count).to eq(2)
      end
    end

    context "product and service" do
      it "returns review count" do
        company = Company.create! valid_company
        service = company.services.create! valid_service
        service.reviews.create! valid_service_review
        service.reviews.create! valid_service_review
        product = company.products.create! valid_product
        product.reviews.create! valid_product_review
        product.reviews.create! valid_product_review
        company.reload
        expect(company.reviews_count).to eq(4)
      end
    end
  end

  describe "strengths" do
    context "no product and service" do
      it "returns empty array" do
        company = Company.create! valid_company
        expect(company.strengths).to eq([])
      end
    end

    context "no product" do
      it "returns service strengths" do
        company = Company.create! valid_company
        service = company.services.create! valid_service
        review = service.reviews.create! valid_service_review

        expect(company.strengths).to eq(review.strengths)
      end
    end

    context "no service" do
      it "returns product strengths" do
        company = Company.create! valid_company
        product = company.products.create! valid_product
        review = product.reviews.create! valid_product_review
        expect(company.strengths).to eq(review.strengths)
      end
    end

    context "does not add discarded products and services" do
      it "returns 0" do
        company = Company.create! valid_company
        service = company.services.create! valid_service
        service.reviews.create! valid_service_review
        product = company.products.create! valid_product
        product.reviews.create! valid_product_review
        service.discard
        product.discard
        expect(company.strengths).to eq([])
      end
    end

    context "does not count discarded reviews" do
      it "returns 0" do
        company = Company.create! valid_company
        service = company.services.create! valid_service
        service.reviews.create! valid_service_review
        product = company.products.create! valid_product
        product.reviews.create! valid_product_review
        service.reviews.first.discard
        product.reviews.first.discard
        expect(company.strengths).to eq([])
      end
    end

    context "product and service" do
      it "returns review strengths" do
        company = Company.create! valid_company
        service = company.services.create! valid_service
        service_review = service.reviews.create! valid_service_review
        product = company.products.create! valid_product
        product_review = product.reviews.create! valid_product_review
        expect(company.strengths).to eq((product_review.strengths + service_review.strengths)[0..5])
      end
    end
  end

  describe "add_score" do
    it "returns the new score" do
      company = Company.new(valid_company)
      product = company.products.new(valid_product)
      review = product.reviews.new(valid_product_review)
      expect(company.add_score(review.score)).to eq(review.score)
    end
  end

  describe "update_score" do
    it "returns the new score" do
      company = Company.create! valid_company
      product = company.products.create! valid_product
      review = product.reviews.create! valid_product_review
      company.aggregate_score = review.score
      newscore = Float(FFaker.numerify('#'))
      expect(company.update_score(review.score, newscore)).to eq(newscore)
    end
  end

  describe "subtract_score" do
    it "returns the new score" do
      company = Company.create! valid_company
      product = company.products.create! valid_product
      review = product.reviews.create! valid_product_review
      company.reload
      company.aggregate_score = review.score
      expect(company.subtract_score(review.score)).to eq(0)
    end
  end
end
