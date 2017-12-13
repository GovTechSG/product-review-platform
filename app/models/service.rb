class Service < ApplicationRecord
  belongs_to :company
  has_many :reviews, as: :reviewable
end
