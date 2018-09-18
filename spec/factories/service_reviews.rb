FactoryBot.define do
  factory :service_review, parent: :review do
    association :reviewable, factory: :service
    after(:create) do |review|
      review.reviewable.company_ids += [review.vendor_id]
    end
  end
end