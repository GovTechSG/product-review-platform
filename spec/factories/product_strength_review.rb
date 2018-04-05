FactoryBot.define do
  factory :product_aspect_review, parent: :aspect_review do
    association :review, factory: :product_review
  end
end