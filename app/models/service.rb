class Service < ApplicationRecord
  include SwaggerDocs::Service
  include Statistics::ProductsAndServices

  belongs_to :company
  has_many :reviews, as: :reviewable, dependent: :destroy

  validates_presence_of :name, :description, :company

  def presence?
    !discarded? && company.presence?
  end
end
