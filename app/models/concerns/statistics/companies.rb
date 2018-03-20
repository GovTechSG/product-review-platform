require 'set'

module Statistics::Companies
  extend ActiveSupport::Concern

  included do
    def strengths
      product_strength_set = get_reviews(self.products.kept)
      service_strength_set = get_reviews(self.services.kept)
      whole_set = product_strength_set.merge(service_strength_set)
      whole_set.empty? ? [] : whole_set.first(6).to_a
    end

    def add_score(score)
      # Get current total score and add latest score to it
      # Then divide by total number of reviews + 1 (+1 because latest review not yet
      # saved to database)
      if reviews_count > 0
        ((reviews_count * aggregate_score) + score)/(reviews_count + 1)
      else
        score
      end
    end

    def update_score(old_score, updated_score)
      if reviews_count > 0
        ((reviews_count * aggregate_score) - old_score + updated_score)/reviews_count
      else
        updated_score
      end
    end

    def subtract_score(score)
      final_score = ((reviews_count * aggregate_score) - score)/(reviews_count - 1)
      final_score.nan? || final_score.infinite? ? 0 : final_score
    end

    private

    def get_reviews(product_service)
      strengths_set = Set.new
      product_service.first(3).each do |reviewable|
        reviewable.reviews.kept.first(3).each do |review|
          strengths_set.merge(serialize(review.strengths))
        end
      end
      strengths_set
    end

    def serialize(strengths)
      strengths.map do |strength|
        strength = ActiveModel::SerializableResource.new(strength)
        strength.as_json
      end
    end
  end
end
