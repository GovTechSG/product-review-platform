class Grant < ApplicationRecord
  include SwaggerDocs::Grant
  include Discard::Model

  belongs_to :agency

  has_many :reviews, dependent: :destroy

  validates :description, :acronym, :user, :name, presence: true
  validates :name, uniqueness: true

  def presence?
    !discarded? && agency.presence?
  end
end
