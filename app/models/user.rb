class User < ApplicationRecord
  include SwaggerDocs::User

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :grants, dependent: :destroy

  validates :name, :email, :number, presence: true
end
