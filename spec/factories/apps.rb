FactoryBot.define do
  factory :app do
    name { FFaker::Name.name }
    password { FFaker::Internet.password }
  end
end