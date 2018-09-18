FactoryBot.define do
  factory :project_review, parent: :review do
    association :reviewable, factory: :project
    after(:create) do |review|
      review.reviewable.company_ids += [review.vendor_id]
    end
  end
end