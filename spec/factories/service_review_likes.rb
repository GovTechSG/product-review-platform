FactoryBot.define do
  factory :service_review_like, parent: :like do
    association :likeable, factory: :service_review
  end
end