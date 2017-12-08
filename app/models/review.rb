class Review < ApplicationRecord
  belongs_to :agency
  belongs_to :product
  belongs_to :service

  has_many :likes
  has_many :comments
end
