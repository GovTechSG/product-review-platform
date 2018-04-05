require 'rails_helper'
require 'concerns/statistics/companies_spec.rb'
require 'concerns/imageable_spec.rb'

RSpec.describe Company, type: :model do
  it_behaves_like "companies"
  it_behaves_like "imageable"
  it "is valid with valid attributes" do
    expect(build(:company)).to be_valid
  end
  it "is not valid without a name" do
    company = build(:company)
    company.name = ''
    expect(company).to_not be_valid
  end
  it "is not valid without a description" do
    company = build(:company)
    company.description = ''
    expect(company).to_not be_valid
  end
  it "is not valid without a uen" do
    company = build(:company)
    company.uen = ''
    expect(company).to_not be_valid
  end
  it "is not valid without a aggregate_score" do
    company = build(:company)
    company.aggregate_score = ''
    expect(company).to_not be_valid
  end
  it "is not valid without a reviews_count" do
    company = build(:company)
    company.reviews_count = nil
    expect(company).to_not be_valid
  end
  it 'is invalid with a duplicate uen' do
    company = build(:company)
    company.save
    expect(build(:company, uen: company.uen)).not_to be_valid
  end
  it 'is invalid with a duplicate name' do
    company = build(:company)
    company.save
    expect(build(:company, name: company.name)).not_to be_valid
  end
  it "is valid without a url" do
    company = build(:company)
    company.url = ''
    expect(company).to be_valid
  end
  it "is not valid with an invalid url" do
    company = build(:company)
    company.url = 'hey'
    expect(company).to_not be_valid
  end

  it "is valid with a valid url" do
    company = build(:company)
    expect(company).to be_valid
  end

  it "is valid with an image" do
    company = build(:company)
    expect(company).to be_valid
  end

  context "grants" do
    it "returns only the companies grants" do
      review = create(:product_review)
      create_list(:product_review, 5)
      expect(review.reviewable.company.grants.length).to eq(1)
    end

    it "returns empty array if there are no grants" do
      company = create(:company)
      expect(company.grants).to eq([])
    end

    it "does not return duplicate grants" do
      review = create(:product_review)
      create(:product_review, grant_id: review.grant_id, reviewable_id: review.reviewable_id, reviewable_type: review.reviewable_type)
      expect(review.reviewable.company.grants.length).to eq(1)
    end

    it "does not return deleted grants" do
      review = create(:product_review)
      review.grant.discard
      expect(review.reviewable.company.grants.length).to eq(0)
    end

    it "does not return grants from deleted reviews" do
      review = create(:product_review)
      review.discard
      expect(review.reviewable.company.grants.length).to eq(0)
    end

    it "does not return grants from deleted product" do
      review = create(:product_review)
      review.reviewable.discard
      expect(review.reviewable.company.grants.length).to eq(0)
    end
  end

  context "clients" do
    let(:company) { create(:company) }
    it "returns empty array if there are no clients" do
      company = create(:company)
      expect(company.clients).to eq([])
    end

    it "does not return deleted clients" do
      product = company.products.create! build(:product).attributes
      product.reviews.create! build(:product_review).attributes
      product.reviews.first.reviewer.discard
      expect(product.company.clients.length).to eq(0)
    end

    it "returns product clients if there are only product clients" do
      product = company.products.create! build(:product).attributes
      product.reviews.create! build(:product_review).attributes
      expect(product.company.clients.length).to eq(1)
    end

    it "does not display duplicate products reviews" do
      product = company.products.create! build(:product).attributes
      review = build(:product_review).attributes
      product.reviews.create! review
      product.reviews.create! review
      expect(product.company.clients.length).to eq(1)
    end

    it "does not display duplicate service reviews" do
      service = company.products.create! build(:product).attributes
      review = build(:service_review).attributes
      service.reviews.create! review
      service.reviews.create! review
      expect(service.company.clients.length).to eq(1)
    end

    it "returns service clients if there are only service clients" do
      service = company.services.create! build(:service).attributes
      service.reviews.create! build(:service_review).attributes
      expect(service.company.clients.length).to eq(1)
    end

    it "does not return deleted products" do
      product = company.products.create! build(:product).attributes
      product.reviews.create! build(:product_review).attributes
      product.discard
      expect(product.company.clients.length).to eq(0)
    end

    it "does not return deleted services" do
      service = company.services.create! build(:service).attributes
      service.reviews.create! build(:service_review).attributes
      service.discard
      expect(service.company.clients.length).to eq(0)
    end

    it "does not return deleted products review" do
      product = company.products.create! build(:product).attributes
      review = product.reviews.create! build(:product_review).attributes
      review.discard
      expect(product.company.clients.length).to eq(0)
    end

    it "does not return deleted services review" do
      service = company.services.create! build(:service).attributes
      review = service.reviews.create! build(:service_review).attributes
      review.discard
      expect(service.company.clients.length).to eq(0)
    end

    it "returns product and service clients" do
      product = company.products.create! build(:product).attributes
      product.reviews.create! build(:product_review).attributes
      service = company.services.create! build(:service).attributes
      service.reviews.create! build(:service_review).attributes
      expect(product.company.clients.length).to eq(2)
    end
  end
end
