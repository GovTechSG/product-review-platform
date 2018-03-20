class Agency < ApplicationRecord
  include SwaggerDocs::Agency

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :grants, dependent: :destroy

  validates :name, :acronym, :kind, :description, presence: true
  validates :name, uniqueness: true
  validates :email, allow_blank: true, email: true
  validates :kind, inclusion: { in: ["Ministry", "Statutory Board", "Agency"],
                                message: "Kind must be any of these: Ministry, Statutory Board, Agency" }
end
