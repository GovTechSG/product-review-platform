class AgencySerializer < ActiveModel::Serializer
  attribute :type, if: :type?
  attributes :id, :name, :email, :phone_number, :acronym, :kind, :description

  def type
    I18n.t('agency.key').to_s
  end

  def type?
    if instance_options[:has_type]
      false
    elsif instance_options[:has_type].nil?
      true
    end
  end
end
