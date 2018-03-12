FactoryBot.define do
  factory :review do
    score { rand(1..10) }
    content { FFaker::Lorem.paragraph }
    strengths { FFaker::Lorem.sentences }
    association :reviewer, factory: :company
    grant
  end
end