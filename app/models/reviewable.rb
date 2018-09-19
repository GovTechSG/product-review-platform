class Reviewable < ApplicationRecord
  include Statistics::ScoreAggregator

  has_many :reviews, as: :reviewable, dependent: :destroy

  after_save :set_discard, on: [:update]
  self.abstract_class = true

  def set_reviews_count
    self.reviews_count = reviews.kept.count
    save!
    reload
  end

  def set_aggregate_score
    self.aggregate_score = reviews.kept.count > 0 ? calculate_aggregate_score(reviews.kept) : 0
    save!
    reload
  end

  def presence?
    return false if discarded?
    CompanyReviewable.where(reviewable_type: self.class.name, reviewable_id: id).find_each do |company_reviewable|
      return true if !company_reviewable.company.discarded?
    end
  end

  def set_discard
    if discarded?
      CompanyReviewable.where(reviewable_type: self.class.name, reviewable_id: id).find_each do |company_reviewable|
        company_reviewable.discard
        company_reviewable.save!
      end
    end
  end
end
