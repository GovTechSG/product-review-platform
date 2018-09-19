class ServiceSerializer < ApplicationSerializer
  attribute :type, if: :type?
  attributes :id, :name, :description, :reviews_count, :companies

  def type
    "Service"
  end

  def type?
    if instance_options[:has_type]
      false
    elsif instance_options[:has_type].nil?
      true
    end
  end
end
