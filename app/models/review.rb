class Review < ApplicationRecord
  belongs_to :agency
  belongs_to :product
  belongs_to :service

  has_many :comments
  has_many :likes
end
