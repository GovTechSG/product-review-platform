require "letter_avatar/has_avatar"

class Company < Reviewer
  include SwaggerDocs::Company
  include LetterAvatar::HasAvatar
  include Statistics::Companies
  include Imageable
  mount_uploader :image, ImageUploader

  include Liker
  include Commenter

  # These refer to the reviews written by a claimant company
  # (different from reviews_count, see models/concerns/statistics/companies.rb)
  has_many :reviews, dependent: :destroy, as: :reviewer
  has_many :likes, dependent: :destroy, as: :liker
  has_many :comments, dependent: :destroy, as: :commenter

  has_many :products, dependent: :destroy
  has_many :services, dependent: :destroy
  has_many :industry_companies, dependent: :destroy
  has_many :industries, through: :industry_companies

  validates_presence_of :name, :uen, :aggregate_score, :description, :reviews_count
  validates_uniqueness_of :uen, :name
  validates :url, allow_blank: true, url: true
  validates :image, file_size: { less_than: 1.megabytes }

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
    if all_reviewers.nil?
      []
    else
      Company.kept.where(id: all_reviewers.uniq)
    end
  end

  def projects
    if all_reviewers.nil?
      []
    else
      company_ids = Company.kept.where(id: all_reviewers.uniq).pluck(:id)
      if company_ids.nil?
        []
      else
        industry_ids = IndustryCompany.kept.where(company_id: company_ids).pluck(:industry_id).uniq
        if industry_ids.nil?
          []
        else
          Industry.kept.where(id: industry_ids)
        end
      end
    end
  end

  class << self
    def sort(sort_by)
      case sort_by
      when 'best_ratings'
        kept.order('aggregate_score asc')
      end
    end
  end

  private

  def all_reviewers
    product_reviewers = Review.match_reviewable(products.kept.pluck(:id), "Product").kept.pluck(:reviewer_id)
    service_reviewers = Review.match_reviewable(services.kept.pluck(:id), "Service").kept.pluck(:reviewer_id)
    product_reviewers + service_reviewers
  end
end
