module Statistics::ScoreAggregator
  extend ActiveSupport::Concern

  included do
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/PerceivedComplexity
    def calculate_aggregate_score(aggregated_reviews)
      if aggregated_reviews.count > 0
        if aggregated_reviews.respond_to?(:where)
          positive_reviews = aggregated_reviews.where(score: Review::POSITIVE)
          neutral = 1.0 * aggregated_reviews.where(score: Review::NEUTRAL).count * Review::NEUTRAL
          negative = 1.0 * aggregated_reviews.where(score: Review::NEGATIVE).count * Review::NEGATIVE
        else
          positive_reviews = aggregated_reviews.select { |review| review.score == Review::POSITIVE }
          neutral = 1.0 * aggregated_reviews.select { |review| review.score == Review::NEUTRAL }.count * Review::NEUTRAL
          negative = 1.0 * aggregated_reviews.select { |review| review.score == Review::NEGATIVE }.count * Review::NEGATIVE
        end
        positive = 1.0 * positive_reviews.count * Review::POSITIVE
        weighted_score = (((positive + neutral + negative) / aggregated_reviews.count) / 3) * 9.0

        number_of_positive_aspects = positive_reviews.map(&:aspects).count
        number_of_aspects_category = Aspect.kept.count
        weighted_aspects =
          if positive_reviews.count != 0 && number_of_aspects_category != 0
            ((number_of_positive_aspects / positive_reviews.count) / number_of_aspects_category) * 1.0
          else
            0.0
          end

        weighted_total = weighted_aspects + weighted_score

        pro_rater = {}
        pro_rater[5] = 0.0
        pro_rater[20] = 0.85
        pro_rater[50] = 0.90
        pro_rater[100] = 0.95

        pro_rater.each_key do |max|
          if aggregated_reviews.count <= max
            weighted_total *= pro_rater[max]
            break
          end
        end
        weighted_total
      else
        0.0
      end
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/PerceivedComplexity
  end
end