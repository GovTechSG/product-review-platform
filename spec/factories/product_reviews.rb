FactoryBot.define do
  factory :product_review, parent: :review do
    association :reviewable, factory: :product
    after(:create) do |review|
      review.reviewable.company_ids += [review.vendor_id]
    end
  end
end