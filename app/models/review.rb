class Review < ApplicationRecord
  belongs_to :agency
  belongs_to :reviewable, polymorphic: true

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates_presence_of :score, :content, :agency, :reviewable
end
