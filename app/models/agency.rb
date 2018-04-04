class Agency < ApplicationRecord
  include SwaggerDocs::Agency
  include Liker
  include Commenter

  has_many :likes, dependent: :destroy, as: :liker
  has_many :comments, dependent: :destroy, as: :commenter
  has_many :grants, dependent: :destroy

  validates :name, :acronym, :kind, :description, presence: true
  validates :name, uniqueness: true
  validates :email, allow_blank: true, email: true
  validates :kind, inclusion: { in: ["Ministry", "Statutory Board", "Agency"],
                                message: I18n.t('agency.kind_restriction').to_s }
end
