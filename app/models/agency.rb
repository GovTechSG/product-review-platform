class Agency < ApplicationRecord
  has_many :reviews
  has_many :likes
  has_many :comments
end
