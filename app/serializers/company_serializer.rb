class CompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :uen, :aggregate_score, :description, :reviews_count, :strengths
  has_many :industries, serializer: IndustrySerializer
end
