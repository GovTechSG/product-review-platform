class Review < ApplicationRecord
  belongs_to :agency
  belongs_to :reviewable, polymorphic: true

  has_many :likes
  has_many :comments
end
