module Statistics::ProductsAndServices
  extend ActiveSupport::Concern

  included do
    def reviews_count
      self.reviews.kept.count
    end

    def aggregate_score
      score = 0
      if self.reviews.kept.count > 0
        score = self.reviews.kept.sum(:score)
        return score.to_f/self.reviews.kept.count
      end
      score
    end

    def company_name
      self.company.name
    end
  end
end