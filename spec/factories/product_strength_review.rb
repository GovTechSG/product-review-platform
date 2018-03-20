FactoryBot.define do
  factory :product_strength_review, parent: :strength_review do
    association :review, factory: :product_review
  end
end