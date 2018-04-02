require "letter_avatar/has_avatar"

class Company < Reviewer
  include SwaggerDocs::Company
  include LetterAvatar::HasAvatar
  include Statistics::Companies
  include Imageable
  mount_uploader :image, ImageUploader

  # These refer to the reviews written by a claimant company
  # (different from reviews_count, see models/concerns/statistics/companies.rb)
  has_many :reviews, dependent: :destroy, as: :reviewer

  has_many :products, dependent: :destroy
  has_many :services, dependent: :destroy
  has_many :industry_companies, dependent: :destroy
  has_many :industries, through: :industry_companies

  validates_presence_of :name, :uen, :aggregate_score, :description, :reviews_count
  validates_uniqueness_of :uen, :name
  validates :url, allow_blank: true, url: true
  validates :image, file_size: { less_than: 1.megabytes }, presence: true

  def grants
    product_grants = Review.match_reviewable(products.kept.pluck(:id), "Product").kept.pluck(:grant_id)
    service_grants = Review.match_reviewable(services.kept.pluck(:id), "Service").kept.pluck(:grant_id)
    all_grants = product_grants + service_grants
    if all_grants.nil?
      []
    else
      Grant.kept.where(id: all_grants.uniq)
    end
  end

  def clients
    product_reviewers = Review.match_reviewable(products.kept.pluck(:id), "Product").kept.pluck(:reviewer_id)
    service_reviewers = Review.match_reviewable(services.kept.pluck(:id), "Service").kept.pluck(:reviewer_id)
    all_reviewers = product_reviewers + service_reviewers
    if all_reviewers.nil?
      []
    else
      Company.kept.where(id: all_reviewers.uniq)
    end
  end
end
