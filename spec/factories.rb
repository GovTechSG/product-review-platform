# Creating test data
# Current implementation only test that ApiController works with
# ApplicationController. Other tests will be added with later user stories
FactoryBot.define do
  factory :user do
    username 'Joe'
    email 'joe@gmail.com'
    password 'blah'
  end
end
