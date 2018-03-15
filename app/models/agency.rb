class Agency < ApplicationRecord
  include SwaggerDocs::Agency

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :grants, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :email, allow_blank: true, email: true
end
