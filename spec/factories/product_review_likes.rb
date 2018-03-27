FactoryBot.define do
  factory :product_review_like, parent: :like do
    association :likeable, factory: :product_review
  end
end