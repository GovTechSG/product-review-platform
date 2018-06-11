class VendorListingSerializer < ApplicationSerializer
  attributes :id, :name, :ratings, :reviews_count, :image, :positive, :neutral, :negative
  has_many :industries, serializer: IndustrySerializer
  has_many :project_industries, serializer: IndustrySerializer

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
