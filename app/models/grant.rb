class Grant < ApplicationRecord
  include SwaggerDocs::Grant
  include Discard::Model

  belongs_to :user

  validates :description, :name, presence: true
  validates :name, uniqueness: true

  def presence?
    !discarded? && user.presence?
  end
end
