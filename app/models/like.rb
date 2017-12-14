class Like < ApplicationRecord
  belongs_to :agency
  belongs_to :review

  validates_presence_of :agency, :review
end
