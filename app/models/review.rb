class Review < ApplicationRecord
  include SwaggerDocs::Review
  include Statistics::Reviews

  belongs_to :reviewer, polymorphic: true
  belongs_to :grant
  belongs_to :reviewable, polymorphic: true

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates_presence_of :score, :content, :reviewer, :reviewable, :grant

  def presence?
    !discarded? && reviewable.presence? && grant.presence? && reviewer.presence?
  end
end
