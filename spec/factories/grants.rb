FactoryBot.define do
  factory :grant do
    name { FFaker::Name.name }
    acronym { FFaker::Name.name }
    description { FFaker::Lorem.paragraph }
    agency
  end
end
