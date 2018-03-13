FactoryBot.define do
  factory :agency do
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
    number { FFaker::PhoneNumberSG.fixed_line_number }
  end
end