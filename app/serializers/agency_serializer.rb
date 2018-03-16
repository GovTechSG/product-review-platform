class AgencySerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :phone_number, :acronym, :kind, :description
end
