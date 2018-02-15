class User < ApplicationRecord
  include SwaggerDocs::User
  include Discard::Model
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates_presence_of :name, :email, :number
end
