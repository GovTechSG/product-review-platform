class Product < ApplicationRecord
  include SwaggerDocs::Product
  include Statistics::ProductsAndServices
  include Discard::Model

  belongs_to :company
  has_many :reviews, as: :reviewable, dependent: :destroy

  validates_presence_of :name, :description, :company
end
