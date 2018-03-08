class ProductSerializer < ActiveModel::Serializer
  attribute :type, if: :type?
  attributes :id, :name, :description
  belongs_to :company, serializer: CompanySerializer

  def type
    'Product'
  end

  def type?
    if instance_options[:has_type]
      false
    elsif instance_options[:has_type].nil?
      true
    end
  end
end
