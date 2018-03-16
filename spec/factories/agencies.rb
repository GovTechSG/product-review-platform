FactoryBot.define do
  factory :agency do
    name { FFaker::Name.name }
    acronym { FFaker::NatoAlphabet.code }
    kind { ["Ministry", "Statutory Board", "Agency"].sample }
    description { FFaker::Lorem.paragraph }
    email { FFaker::Internet.email }
    phone_number { FFaker::PhoneNumberSG.fixed_line_number }
  end
end