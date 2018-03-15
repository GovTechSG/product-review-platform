FactoryBot.define do
  factory :comment do
    content { FFaker::Lorem.paragraph }
    agency
  end
end