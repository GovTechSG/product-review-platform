require 'set'

module Statistics::Companies
  extend ActiveSupport::Concern

  included do
    # These refer to the aggregate number of reviews of a vendor company's products and services
    # (different from #reviews method on company, see models/company.rb)
    def reviews_count
      product_count = self.products.reduce(0) { |accum, product| accum + product.reviews.count }
      total_count = product_count + self.services.reduce(0) { |accum, service| accum + service.reviews.count }
      total_count
    end

    def strengths
      product_strength_set = get_reviews(self.products)
      service_strength_set = get_reviews(self.services)
      whole_set = product_strength_set.merge(service_strength_set)
      whole_set.empty? ? [] : whole_set.first(6).to_a
    end

    def add_score(score)
      # Get current total score and add latest score to it
      # Then divide by total number of reviews + 1 (+1 because latest review not yet
      # saved to database)
      count = reviews_count
      if count > 0
        ((count * aggregate_score) + score)/(count + 1)
      else
        score
      end
    end

    def update_score(old_score, updated_score)
      count = reviews_count
      if count > 0
        ((count * aggregate_score) - old_score + updated_score)/count
      else
        updated_score
      end
    end

    def subtract_score(score)
      count = reviews_count
      final_score = ((count * aggregate_score) - score)/(count - 1)
      final_score.nan? || final_score.infinite? ? 0 : final_score
    end

    private

    def get_reviews(product_service)
      strengths_set = Set.new
      product_service.first(3).each do |reviewable|
        reviewable.reviews.first(3).each do |review|
          strengths_set.merge(review.strengths)
        end
      end
      strengths_set
    end
  end
end
