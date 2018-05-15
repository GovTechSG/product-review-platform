FactoryBot.define do
  factory :project_review_like, parent: :like do
    association :likeable, factory: :project_review
  end
end