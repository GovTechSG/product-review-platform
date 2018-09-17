class Reviewable < ApplicationRecord
  include Statistics::ScoreAggregator

  has_many :reviews, as: :reviewable, dependent: :destroy
  self.abstract_class = true

  # after_save :set_company_reviews_count, on: [:create, :update]
  # after_destroy :set_company_reviews_count
  # after_save :set_company_score, on: [:create, :update]
  # after_destroy :set_company_score

  # def set_reviews_count
  #   self.reviews_count = reviews.kept.count
  #   save!
  #   reload
  # end

  # def set_aggregate_score
  #   self.aggregate_score = reviews.kept.count > 0 ? calculate_aggregate_score(reviews.kept) : 0
  #   save!
  #   reload
  # end

  # def presence?
  #   !discarded? && company.presence?
  # end

  # def set_company_reviews_count
  #   company.set_reviews_count
  # end

  # def set_company_score
  #   company.set_aggregate_score
  # end
end
