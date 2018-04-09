class AssociateCompanySerializer < ActiveModel::Serializer
  attribute :type, if: :type?
  attributes :id, :name, :uen, :aggregate_score, :description, :reviews_count, :image

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

  def id
    object.hashid
  end
end
