FactoryBot.define do
  factory :service_strength_review, parent: :strength_review do
    association :review, factory: :service_review
  end
end