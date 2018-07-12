FactoryBot.define do
  factory :app do
    name { FFaker::Name.name }
    password { FFaker::Internet.password }
    scopes ["read_write"]
  end
  factory :read_only_app do
    name { FFaker::Name.name }
    password { FFaker::Internet.password }
    scopes ["read_only"]
  end
  factory :write_only_app do
    name { FFaker::Name.name }
    password { FFaker::Internet.password }
    scopes ["write_only"]
  end
end