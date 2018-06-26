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

    it "returns all reviewable by default" do
      review = create(:product_review)
      company = review.reviewable.company
      service = company.services.create!(build(:service).attributes)
      service.reviews.create!(build(:service_review).attributes)
      project = company.projects.create!(build(:project).attributes)
      project.reviews.create!(build(:project_review).attributes)
      expect(review.reviewable.company.grants.length).to eq(3)
    end

    it "returns all product when specified" do
      review = create(:product_review)
      company = review.reviewable.company
      service = company.services.create!(build(:service).attributes)
      service.reviews.create!(build(:service_review).attributes)
      project = company.projects.create!(build(:project).attributes)
      project.reviews.create!(build(:project_review).attributes)
      expect(review.reviewable.company.grants("Product").length).to eq(1)
    end

    it "returns all service when specified" do
      review = create(:product_review)
      company = review.reviewable.company
      service = company.services.create!(build(:service).attributes)
      service.reviews.create!(build(:service_review).attributes)
      project = company.projects.create!(build(:project).attributes)
      project.reviews.create!(build(:project_review).attributes)
      expect(review.reviewable.company.grants("Service").length).to eq(1)
    end

    it "returns all project when specified" do
      review = create(:product_review)
      company = review.reviewable.company
      service = company.services.create!(build(:service).attributes)
      service.reviews.create!(build(:service_review).attributes)
      project = company.projects.create!(build(:project).attributes)
      project.reviews.create!(build(:project_review).attributes)
      expect(review.reviewable.company.grants("Project").length).to eq(1)
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

    it "returns grants sorted by reviews_count when specified" do
      company = create(:company)
      product = company.products.create! build(:product).attributes
      review = product.reviews.create! build(:product_review).attributes
      review.grant.reviews.create! build(:product_review).attributes
      service = company.services.create! build(:service).attributes
      service.reviews.create! build(:service_review).attributes
      project = company.projects.create! build(:project).attributes
      project.reviews.create! build(:project_review).attributes
      expect(product.company.grants(nil, "reviews_count")[0]).not_to eq(product.reviews.first.grant)
    end

    it "returns grants sorted by reviews_count by desc when specified" do
      company = create(:company)
      product = company.products.create! build(:product).attributes
      review = product.reviews.create! build(:product_review).attributes
      review.grant.reviews.create! build(:product_review).attributes
      service = company.services.create! build(:service).attributes
      service.reviews.create! build(:service_review).attributes
      project = company.projects.create! build(:project).attributes
      project.reviews.create! build(:project_review).attributes
      expect(product.company.grants(nil, "reviews_count", "true")[0]).to eq(product.reviews.first.grant)
    end
  end

  context "clients" do
    let(:company) { create(:company) }
    it "returns empty array if there are no clients" do
      company = create(:company)
      expect(company.clients).to eq([])
    end

    it "returns all product when specified" do
      review = create(:product_review)
      company = review.reviewable.company
      service = company.services.create!(build(:service).attributes)
      service.reviews.create!(build(:service_review).attributes)
      project = company.projects.create!(build(:project).attributes)
      project.reviews.create!(build(:project_review).attributes)
      expect(review.reviewable.company.clients("Product").length).to eq(1)
    end

    it "returns all service when specified" do
      review = create(:product_review)
      company = review.reviewable.company
      service = company.services.create!(build(:service).attributes)
      service.reviews.create!(build(:service_review).attributes)
      project = company.projects.create!(build(:project).attributes)
      project.reviews.create!(build(:project_review).attributes)
      expect(review.reviewable.company.clients("Service").length).to eq(1)
    end

    it "returns all project when specified" do
      review = create(:product_review)
      company = review.reviewable.company
      service = company.services.create!(build(:service).attributes)
      service.reviews.create!(build(:service_review).attributes)
      project = company.projects.create!(build(:project).attributes)
      project.reviews.create!(build(:project_review).attributes)
      expect(review.reviewable.company.clients("Project").length).to eq(1)
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

    it "returns clients sorted by created_at when specified" do
      product = company.products.create! build(:product).attributes
      product.reviews.create! build(:product_review).attributes
      service = company.services.create! build(:service).attributes
      service.reviews.create! build(:service_review).attributes
      project = company.projects.create! build(:project).attributes
      project.reviews.create! build(:project_review).attributes
      expect(product.company.clients(nil, "created_at")[0]).to eq(product.reviews.first.reviewer)
    end

    it "returns clients sorted by created_at by desc when specified" do
      product = company.products.create! build(:product).attributes
      product.reviews.create! build(:product_review).attributes
      service = company.services.create! build(:service).attributes
      service.reviews.create! build(:service_review).attributes
      project = company.projects.create! build(:project).attributes
      project.reviews.create! build(:project_review).attributes
      expect(product.company.clients(nil, "created_at", "true")[0]).to eq(project.reviews.first.reviewer)
    end
  end

  context "reviewable_industries" do
    let(:company) { create(:company) }
    it "returns empty array if there are no reviewables" do
      company = create(:company)
      expect(company.reviewable_industries).to eq([])
    end

    it "does not return deleted reviewables" do
      product = company.products.create! build(:product).attributes
      product.reviews.create! build(:product_review).attributes
      product.reviews.first.reviewer.industries.create! build(:industry).attributes
      product.reviews.first.reviewer.industries.first.discard
      expect(product.company.reviewable_industries.length).to eq(0)
    end

    it "returns all reviewables by default" do
      product = company.products.create! build(:product).attributes
      product.reviews.create! build(:product_review).attributes
      product.reviews.first.reviewer.industries.create! build(:industry).attributes
      service = company.services.create! build(:service).attributes
      service.reviews.create! build(:service_review).attributes
      service.reviews.first.reviewer.industries.create! build(:industry).attributes
      project = company.projects.create! build(:project).attributes
      project.reviews.create! build(:project_review).attributes
      project.reviews.first.reviewer.industries.create! build(:industry).attributes
      expect(company.reviewable_industries.length).to eq(3)
    end

    it "returns product when specified" do
      product = company.products.create! build(:product).attributes
      product.reviews.create! build(:product_review).attributes
      product.reviews.first.reviewer.industries.create! build(:industry).attributes
      service = company.services.create! build(:service).attributes
      service.reviews.create! build(:service_review).attributes
      service.reviews.first.reviewer.industries.create! build(:industry).attributes
      project = company.projects.create! build(:project).attributes
      project.reviews.create! build(:project_review).attributes
      project.reviews.first.reviewer.industries.create! build(:industry).attributes
      expect(company.reviewable_industries("Product").length).to eq(1)
    end

    it "returns service when specified" do
      product = company.products.create! build(:product).attributes
      product.reviews.create! build(:product_review).attributes
      product.reviews.first.reviewer.industries.create! build(:industry).attributes
      service = company.services.create! build(:service).attributes
      service.reviews.create! build(:service_review).attributes
      service.reviews.first.reviewer.industries.create! build(:industry).attributes
      project = company.projects.create! build(:project).attributes
      project.reviews.create! build(:project_review).attributes
      project.reviews.first.reviewer.industries.create! build(:industry).attributes
      expect(company.reviewable_industries("Service").length).to eq(1)
    end

    it "returns project when specified" do
      product = company.products.create! build(:product).attributes
      product.reviews.create! build(:product_review).attributes
      product.reviews.first.reviewer.industries.create! build(:industry).attributes
      service = company.services.create! build(:service).attributes
      service.reviews.create! build(:service_review).attributes
      service.reviews.first.reviewer.industries.create! build(:industry).attributes
      project = company.projects.create! build(:project).attributes
      project.reviews.create! build(:project_review).attributes
      project.reviews.first.reviewer.industries.create! build(:industry).attributes
      expect(company.reviewable_industries("Project").length).to eq(1)
    end
  end

  context "aggregate_score" do
    let(:company) { create(:company) }
    it "returns 0 when there are no review scores" do
      company = create(:company)
      expect(company.aggregate_score).to eq(0.0)
    end

    it "returns aggregate_score" do
      company = create(:company)
      product = company.products.create! build(:product).attributes
      product.reviews.create! build(:product_review).attributes
      expect(company.aggregate_score).not_to eq(0)
    end
  end

  context "aggregate_score" do
    let(:company) { create(:company) }
    it "returns empty when there are no company" do
      expect(Company.sort('aggregate_score')).to eq([])
    end

    it "sorts by best ratings" do
      create_list(:company, 5)
      expect(Company.sort('aggregate_score').count).to eq(5)

      current_value = Company.sort('aggregate_score').first.aggregate_score
      Company.sort('aggregate_score').each do |company|
        expect(company.aggregate_score).to be <= current_value
        current_value = company.aggregate_score
      end
    end
  end

  context "created_at" do
    let(:company) { create(:company) }
    it "returns empty when there are no company" do
      expect(Company.sort('created_at')).to eq([])
    end

    it "sorts by newly added" do
      create_list(:company, 5)
      expect(Company.sort('created_at').count).to eq(5)

      current_date = Company.sort('created_at').first.created_at
      Company.sort('created_at').each do |company|
        expect(company.created_at).to be <= current_date
        current_date = company.created_at
      end
    end
  end
end
