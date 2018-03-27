FactoryBot.define do
  factory :service_review_comment, parent: :comment do
    association :commentable, factory: :service_review
  end
end