class CompanySerializer < ActiveModel::Serializer
  attribute :type, if: :type?
  attributes :id, :name, :uen, :aggregate_score, :description, :reviews_count, :strengths, :url, :phone_number, :image
  has_many :industries, serializer: IndustrySerializer

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
end
