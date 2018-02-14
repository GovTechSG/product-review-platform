FactoryBot.define do
  factory :product_review, parent: :review do
    association :reviewable, factory: :product
  end
end