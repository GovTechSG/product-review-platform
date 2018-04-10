class GrantSerializer < ApplicationSerializer
  attributes :id, :name, :acronym, :description

  belongs_to :agency, serializer: AgencySerializer
end
