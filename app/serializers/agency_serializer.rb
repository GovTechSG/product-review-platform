class AgencySerializer < ActiveModel::Serializer
  attribute :type, if: :type?
  attributes :id, :name, :email, :phone_number, :acronym, :kind, :description, :image

  def type
    "Agency"
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
