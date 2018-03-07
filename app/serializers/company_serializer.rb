class CompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :UEN, :aggregate_score, :description, :reviews_count, :strengths
end
