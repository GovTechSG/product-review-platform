class Comment < ApplicationRecord
  belongs_to :agency
  belongs_to :review
end
