FactoryBot.define do
  factory :product_review_comment, parent: :comment do
    association :review, factory: :product_review
  end
end