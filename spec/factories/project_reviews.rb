FactoryBot.define do
  factory :project_review, parent: :review do
    association :reviewable, factory: :project
  end
end