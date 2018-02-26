class User < ApplicationRecord
  include SwaggerDocs::User
  include Discard::Model
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :name, :email, :number, presence: true
end
