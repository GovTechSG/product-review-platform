FactoryBot.define do
  factory :project_aspect_review, parent: :aspect_review do
    association :review, factory: :project_review
  end
end