FactoryBot.define do
  factory :comment do
    content { FFaker::Lorem.paragraphs }
    agency
  end
end