class AssociateCompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :UEN, :aggregate_score, :description
end
