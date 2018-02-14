FactoryBot.define do
  factory :service_review, parent: :review do
    association :reviewable, factory: :service
  end
end