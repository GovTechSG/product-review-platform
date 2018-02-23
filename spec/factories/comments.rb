FactoryBot.define do
  factory :comment do
    content { FFaker::Lorem.paragraphs }
    user
  end
end