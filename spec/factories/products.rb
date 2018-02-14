FactoryBot.define do
  factory :product do
    name { FFaker::Name.name }
    description { FFaker::Lorem.sentence }
    company
  end
end