FactoryBot.define do
  factory :agency do
    name { FFaker::Name.name }
    acronym { FFaker::NatoAlphabet.code }
    kind { ["Ministry", "Statutory Board", "Agency"].sample }
    description { FFaker::Lorem.paragraph }
    email { FFaker::Internet.email }
    phone_number { FFaker::PhoneNumberSG.fixed_line_number }
    image Rack::Test::UploadedFile.new(Rails.root.join('spec/support/handtinyblack.gif'))
  end

  factory :agency_as_params, class: Hash do
    name { FFaker::Name.name }
    acronym { FFaker::NatoAlphabet.code }
    kind { ["Ministry", "Statutory Board", "Agency"].sample }
    description { FFaker::Lorem.paragraph }
    email { FFaker::Internet.email }
    phone_number { FFaker::PhoneNumberSG.fixed_line_number }
    image "data:image/gif;base64,R0lGODlhAQABAAD/ACwAAAAAAQABAAACADs="

    initialize_with { attributes }
  end
end