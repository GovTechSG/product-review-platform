class AssociateCompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :uen, :aggregate_score, :description
end
