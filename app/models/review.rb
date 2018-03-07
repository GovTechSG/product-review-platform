class Review < ApplicationRecord
  include SwaggerDocs::Review
  include Statistics::Reviews

  belongs_to :company # this is wrong, should be claimant
  belongs_to :reviewable, polymorphic: true

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates_presence_of :score, :content, :company, :reviewable

  def presence?
    !discarded? && reviewable.presence?
  end
end
