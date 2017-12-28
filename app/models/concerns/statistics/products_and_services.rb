module Statistics::ProductsAndServices
  extend ActiveSupport::Concern

  included do
    def reviews_count
      self.reviews.count
    end

    def aggregate_score
      score = 0
      if self.reviews.count > 0
        score = self.reviews.sum(:score)
        return score.to_f/self.reviews.count
      end
      score
    end

    def company_name
      self.company.name
    end
  end
end