class CompanySerializer < ActiveModel::Serializer
  attribute :type, if: :type?
  attributes :id, :name, :UEN, :aggregate_score, :description, :reviews_count, :strengths
  has_many :industries, serializer: IndustrySerializer

  def type
    'Company'
  end

  def type?
    if instance_options[:has_type]
      false
    elsif instance_options[:has_type].nil?
      true
    end
  end
end
