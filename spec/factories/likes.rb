FactoryBot.define do
  factory :like do
    association :liker, factory: :agency
  end
end