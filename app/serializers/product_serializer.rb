class ProductSerializer < ActiveModel::Serializer
  attribute :type, if: :type?
  attributes :id, :name, :description, :reviews_count
  belongs_to :company, serializer: AssociateCompanySerializer

  def type
    I18n.t('product.key').to_s
  end

  def type?
    if instance_options[:has_type]
      false
    elsif instance_options[:has_type].nil?
      true
    end
  end
end
