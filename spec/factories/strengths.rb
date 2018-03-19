FactoryBot.define do
  factory :strength do
    name { FFaker::Lorem.sentence }
    description { FFaker::Lorem.paragraph }
  end
end
