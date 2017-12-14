class Like < ApplicationRecord
  belongs_to :agency
  belongs_to :review

  validates_presence_of :agency, :review
  validates_uniqueness_of :agency_id, uniqueness: { scope: :review_id }
end
