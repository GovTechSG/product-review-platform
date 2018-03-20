class CompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :uen, :aggregate_score, :description, :reviews_count, :strengths, :url, :phone_number
  has_many :industries, serializer: IndustrySerializer
end
