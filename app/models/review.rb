class Review < ApplicationRecord
  include Statistics::Reviews

  belongs_to :company
  belongs_to :reviewable, polymorphic: true

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates_presence_of :score, :content, :company, :reviewable
end
