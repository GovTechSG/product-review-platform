FactoryBot.define do
  factory :aspect do
    name { FFaker::Lorem.sentence }
    description { FFaker::Lorem.paragraph }
  end
end
