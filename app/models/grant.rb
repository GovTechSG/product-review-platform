class Grant < ApplicationRecord
  include SwaggerDocs::Grant
  include Discard::Model

  belongs_to :agency

  has_many :reviews, dependent: :destroy

  validates :description, :acronym, :agency, :name, presence: true
  validates :name, uniqueness: true

  scope :kept, -> { undiscarded.joins(:agency).merge(Agency.kept) }

  def presence?
    !discarded? && agency.presence?
  end
end
