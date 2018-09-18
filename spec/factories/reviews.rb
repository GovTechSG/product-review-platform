FactoryBot.define do
  factory :review do
    score { rand(1..3) }
    content { FFaker::Lorem.paragraph }
    association :reviewer, factory: :company
    association :vendor, factory: :company
    grant
  end
end