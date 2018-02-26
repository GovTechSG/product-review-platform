class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :name, :company_id, :description
end
