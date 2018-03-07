FactoryBot.define do
  factory :industry do
    name { FFaker::Name.name }
    description { FFaker::Lorem.paragraph }
  end
end
