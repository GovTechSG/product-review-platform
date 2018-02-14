FactoryBot.define do
  factory :service_review_comment, parent: :comment do
    association :review, factory: :service_review
  end
end