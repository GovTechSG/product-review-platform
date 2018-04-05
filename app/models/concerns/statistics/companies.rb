require 'set'

module Statistics::Companies
  extend ActiveSupport::Concern

  included do
    def aspects
      product_aspect = Aspect.match_product(self.products.kept.pluck(:id)).first(6)
      service_aspect = Aspect.match_service(self.services.kept.pluck(:id)).first(6)
      whole_set = product_aspect + service_aspect
      whole_set.empty? ? [] : serialize(whole_set.uniq.first(6))
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
      aspects_set = Set.new
      product_service.first(3).each do |reviewable|
        reviewable.reviews.kept.first(3).each do |review|
          aspects_set.merge(serialize(review.aspects))
        end
      end
      aspects_set
    end

    def serialize(aspects)
      aspects.map do |aspect|
        aspect = ActiveModel::SerializableResource.new(aspect)
        aspect.as_json
      end
    end
  end
end
