class CompanySerializer < ApplicationSerializer
  attribute :type, if: :type?
  attributes :id, :name, :ratings, :uen, :aggregate_score, :description, :reviews_count, :aspects, :url, :phone_number, :image, :positive, :neutral, :negative
  has_many :industries, serializer: IndustrySerializer
  has_many :project_industries, serializer: IndustrySerializer

  def type
    "Company"
  end

  def type?
    if instance_options[:has_type]
      false
    elsif instance_options[:has_type].nil?
      true
    end
  end

  def image
    object.image.serializable_hash
  end

  def positive
    object.review_scores.select { |score| score > 0 }.count
  end

  def neutral
    object.review_scores.select(&:zero?).count
  end

  def negative
    object.review_scores.select { |score| score < 0 }.count
  end

  def project_industries
    object.reviewable_industries("Project")
  end
end
