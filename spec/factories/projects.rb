FactoryBot.define do
  factory :project do
    name { FFaker::Name.name }
    description { FFaker::Lorem.sentence }
    company
  end
end