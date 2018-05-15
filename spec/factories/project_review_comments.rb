FactoryBot.define do
  factory :project_review_comment, parent: :comment do
    association :commentable, factory: :project_review
  end
end