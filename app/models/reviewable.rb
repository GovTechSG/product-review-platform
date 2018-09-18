class Reviewable < ApplicationRecord
  include Statistics::ScoreAggregator

  has_many :reviews, as: :reviewable, dependent: :destroy
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
end
