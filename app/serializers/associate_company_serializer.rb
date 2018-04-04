class AssociateCompanySerializer < ActiveModel::Serializer
  attribute :type, if: :type?
  attributes :id, :name, :uen, :aggregate_score, :description, :reviews_count

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
