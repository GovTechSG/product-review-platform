FactoryBot.define do
  factory :company_project, class: CompanyReviewable do
    company
    association :reviewable, factory: :project
  end
  factory :company_service, class: CompanyReviewable do
    company
    association :reviewable, factory: :service
  end
  factory :company_product, class: CompanyReviewable do
    company
    association :reviewable, factory: :product
  end
end
