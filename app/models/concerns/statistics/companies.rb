require 'set'

module Statistics::Companies
  extend ActiveSupport::Concern

  included do
    # These refer to the aggregate number of reviews of a vendor company's products and services
    # (different from #reviews method on company, see models/company.rb)
    def reviews_count
      self.products.reduce(0) { |accum, p| accum + p.reviews.count }
      + self.services.reduce(0) { |accum, s| accum + s.reviews.count }
    end

    def strengths
      strengths = Set.new()
      strengths = get_product_reviews(strengths)
      strengths = get_service_reviews(strengths)
      strengths.to_a
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
      if count > 0
        ((count * aggregate_score) - score)/(count - 1)
      else
        0
      end
    end

    private

    def get_product_reviews(set)
      products.first(3).each do |p|
        p.reviews.first(3).each do |r|
          if set.length >= 5
            return set.to_a[0, 5]
          end
          set.merge(r.strengths)
        end
      end
    end

    def get_service_reviews(set)
      services.first(3).each do |s|
        s.reviews.first(3).each do |r|
          if set.length >= 5
            return set.to_a[0, 5]
          end
          set.merge(r.strengths)
        end
      end
    end
  end
end
