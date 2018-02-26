class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :score, :content, :reviewable_id, :reviewable_type, :strengths, :company_id
end
