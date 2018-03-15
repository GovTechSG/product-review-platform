class AgencySerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :number, :acronym, :kind, :description
end
