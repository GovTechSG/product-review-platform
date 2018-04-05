FactoryBot.define do
  factory :service_aspect_review, parent: :aspect_review do
    association :review, factory: :service_review
  end
end