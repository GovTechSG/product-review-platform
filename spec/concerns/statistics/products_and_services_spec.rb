require 'rails_helper'

shared_examples_for 'products_and_services' do
  let(:valid_product) do
    build(:product).attributes
  end
  let(:valid_service) do
    build(:service).attributes
  end
  let(:valid_project) do
    build(:project).attributes
  end
  let(:valid_product_review) do
    build(:product_review).attributes
  end
  let(:valid_service_review) do
    build(:service_review).attributes
  end
  let(:valid_project_review) do
    build(:service_review).attributes
  end
  let(:valid_company) do
    create(:company)
  end

  describe "reviews_count" do
    context "products" do
      it "returns 0 with no reviews" do
        product = Product.create! valid_product
        expect(product.reviews_count).to eq(0)
      end
      it "returns number of reviews" do
        product = Product.create! valid_product
        product.reviews.create! valid_product_review
        product.reload
        expect(product.reviews_count).to eq(1)
      end

      it "does not count discarded reviews" do
        product = Product.create! valid_product
        product.reviews.create! valid_product_review
        product.reviews.first.discard
        expect(product.reviews_count).to eq(0)
      end
    end

    context "services" do
      it "returns 0 with no reviews" do
        service = Service.create! valid_service
        expect(service.reviews_count).to eq(0)
      end
      it "returns number of reviews" do
        service = Service.create! valid_service
        service.reviews.create! valid_service_review
        service.reload
        expect(service.reviews_count).to eq(1)
      end
      it "does not count discarded reviews" do
        service = Service.create! valid_service
        service.reviews.create! valid_service_review
        service.reviews.first.discard
        expect(service.reviews_count).to eq(0)
      end
    end

    context "projects" do
      it "returns 0 with no reviews" do
        project = Project.create! valid_project
        expect(project.reviews_count).to eq(0)
      end
      it "returns number of reviews" do
        project = Project.create! valid_project
        project.reviews.create! valid_project_review
        project.reload
        expect(project.reviews_count).to eq(1)
      end
      it "does not count discarded reviews" do
        project = Project.create! valid_project
        project.reviews.create! valid_project_review
        project.reviews.first.discard
        expect(project.reviews_count).to eq(0)
      end
    end
  end
end
