class Review < ApplicationRecord
  include SwaggerDocs::Review
  include Statistics::Reviews

  include Commentable
  include Likeable

  belongs_to :reviewer, polymorphic: true
  belongs_to :vendor, class_name: 'Company'

  POSITIVE = 3
  NEUTRAL = 2
  NEGATIVE = 1

  def company
    return unless reviewable_type == "Company"
    super
  end

  belongs_to :grant
  belongs_to :reviewable, polymorphic: true

  has_many :aspect_reviews, dependent: :destroy
  has_many :aspects, through: :aspect_reviews
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  validates_presence_of :score, :reviewer, :reviewable, :grant

  after_save :set_reviewable_reviews_count, on: [:create, :update]
  after_destroy :set_reviewable_reviews_count
  after_save :set_reviewable_score, on: [:create, :update]
  after_destroy :set_reviewable_score

  scope :kept, -> { undiscarded.joins(:grant).merge(Grant.kept) }
  scope :kept, -> { undiscarded.joins(:vendor).merge(Company.kept) }
  scope :match_reviewable, lambda { |vendor_id, reviewable_id, reviewable_type|
    where("(reviewable_type = :reviewable_type AND reviewable_id in (:reviewable_id)) AND vendor_id in (:vendor_id)",
          reviewable_id: reviewable_id,
          reviewable_type: reviewable_type,
          vendor_id: vendor_id)
  }

  def presence?
    !discarded? && reviewable.presence? && grant.presence? && reviewer.presence? && vendor.presence?
  end

  private

  def set_reviewable_reviews_count
    reviewable.set_reviews_count unless reviewable.nil?
    vendor.set_reviews_count unless vendor.nil?
  end

  def set_reviewable_score
    reviewable.set_aggregate_score unless reviewable.nil?
    vendor.set_aggregate_score unless vendor.nil?
  end
end
