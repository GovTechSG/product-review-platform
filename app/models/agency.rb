class Agency < ApplicationRecord
  include SwaggerDocs::Agency
  include Validations

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :grants, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: true
  validate :valid_email?
end
