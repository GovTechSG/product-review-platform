FactoryBot.define do
  factory :review do
    score { rand(1..10) }
    content { FFaker::Lorem.paragraph }
    association :reviewer, factory: :company
    grant
  end
end