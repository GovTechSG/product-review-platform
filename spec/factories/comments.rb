FactoryBot.define do
  factory :comment do
    content { FFaker::Lorem.paragraph }
    association :commenter, factory: :agency
  end
end