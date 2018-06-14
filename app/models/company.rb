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
  has_many :projects, dependent: :destroy
  has_many :services, dependent: :destroy
  has_many :industry_companies, dependent: :destroy
  has_many :industries, through: :industry_companies

  validates_presence_of :name, :uen, :aggregate_score, :description, :reviews_count
  validates_uniqueness_of :uen, :name
  validates :url, allow_blank: true, url: true
  validates :image, file_size: { less_than: 1.megabytes }

  def grants(filter_by = nil)
    accepted_filter = valid_reviewable_filter(filter_by)
    grants = get_grants(accepted_filter)
    if grants.nil?
      []
    else
      Grant.kept.where(id: grants.uniq)
    end
  end

  def clients(filter_by = nil)
    accepted_filter = valid_reviewable_filter(filter_by)
    reviewers = get_reviewers(accepted_filter)
    if reviewers.nil?
      []
    else
      Company.kept.where(id: reviewers.uniq)
    end
  end

  def reviewable_industries(filter_by = nil)
    accepted_filter = valid_reviewable_filter(filter_by)
    reviewers = get_reviewers(accepted_filter)
    if reviewers.nil?
      []
    else
      company_ids = Company.kept.where(id: reviewers.uniq).pluck(:id)
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

  def review_scores
    product_reviews = Review.match_reviewable(products.kept.pluck(:id), "Product").kept.pluck(:score)
    service_reviews = Review.match_reviewable(services.kept.pluck(:id), "Service").kept.pluck(:score)
    project_reviews = Review.match_reviewable(projects.kept.pluck(:id), "Project").kept.pluck(:score)
    product_reviews + service_reviews + project_reviews
  end

  def ratings
    if review_scores.count > 0
      positive = review_scores.select { |score| score > 0 }.count.to_f
      (positive / review_scores.count.to_f) * 100.0
    else
      0.0
    end
  end

  class << self
    def sort(sort_by)
      case sort_by
      when 'best_ratings'
        kept.sort_by(&:ratings).reverse!
      when 'newly_added'
        kept.order(created_at: :desc).to_ary
      end
    end
  end

  private

  def valid_reviewable_filter(filter_by)
    valid_filters = ['Product', 'Service', 'Project']
    valid_filters.include?(filter_by) ? filter_by : nil
  end

  # rubocop:disable Metrics/AbcSize
  def get_reviewers(filter_by = nil)
    case filter_by
    when 'Product'
      Review.match_reviewable(products.kept.pluck(:id), "Product").kept.pluck(:reviewer_id)
    when 'Service'
      Review.match_reviewable(services.kept.pluck(:id), "Service").kept.pluck(:reviewer_id)
    when 'Project'
      Review.match_reviewable(projects.kept.pluck(:id), "Project").kept.pluck(:reviewer_id)
    else
      (Review.match_reviewable(products.kept.pluck(:id), "Product").kept.pluck(:reviewer_id) +
       Review.match_reviewable(services.kept.pluck(:id), "Service").kept.pluck(:reviewer_id) +
       Review.match_reviewable(projects.kept.pluck(:id), "Project").kept.pluck(:reviewer_id))
    end
  end

  def get_grants(filter_by = nil)
    case filter_by
    when 'Product'
      Review.match_reviewable(products.kept.pluck(:id), "Product").kept.pluck(:grant_id)
    when 'Service'
      Review.match_reviewable(services.kept.pluck(:id), "Service").kept.pluck(:grant_id)
    when 'Project'
      Review.match_reviewable(projects.kept.pluck(:id), "Project").kept.pluck(:grant_id)
    else
      (Review.match_reviewable(products.kept.pluck(:id), "Product").kept.pluck(:grant_id) +
       Review.match_reviewable(services.kept.pluck(:id), "Service").kept.pluck(:grant_id) +
       Review.match_reviewable(projects.kept.pluck(:id), "Project").kept.pluck(:grant_id))
    end
  end
  # rubocop:enable Metrics/AbcSize
end
