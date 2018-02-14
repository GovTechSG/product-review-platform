FactoryBot.define do
  factory :service do
    name { FFaker::Name.name }
    description { FFaker::Lorem.sentence }
    company
  end
end