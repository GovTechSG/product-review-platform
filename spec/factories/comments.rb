FactoryBot.define do
  factory :comment do
    content { FFaker::Lorem.paragraph }
    user
  end
end