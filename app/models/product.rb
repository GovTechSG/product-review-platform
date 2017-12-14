class Product < ApplicationRecord
  belongs_to :company
  has_many :reviews, as: :reviewable

  validates_presence_of :name, :description, :company
end
