class Company < ApplicationRecord
  include SwaggerDocs::Company

  has_many :products, dependent: :destroy
  has_many :services, dependent: :destroy

  validates_presence_of :name, :UEN, :aggregate_score
end
