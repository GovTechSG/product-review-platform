module Statistics::ProductsAndServices
  extend ActiveSupport::Concern

  included do
    def reviews_count
      self.reviews.count
    end

    def aggregate_score
      score = 0
      if self.reviews.count > 0
        self.reviews.each { |r| score += r.score }
        return score.to_f/self.reviews.count
      else
        return score
      end
    end

    def company_name
      self.company.name
    end
  end
end