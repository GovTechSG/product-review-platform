class GrantSerializer < ActiveModel::Serializer
  attributes :id, :name, :acronym, :description

  belongs_to :agency, serializer: AgencySerializer
end
