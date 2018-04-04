class CompanySerializer < ActiveModel::Serializer
  attribute :type, if: :type?
  attributes :id, :name, :uen, :aggregate_score, :description, :reviews_count, :strengths, :url, :phone_number
  has_many :industries, serializer: IndustrySerializer

  def type
    I18n.t('company.key').to_s
  end

  def type?
    if instance_options[:has_type]
      false
    elsif instance_options[:has_type].nil?
      true
    end
  end
end
