class Company < ApplicationRecord
  has_many :products
  has_many :services

  validates_presence_of :name, :UEN, :aggregate_score
end
