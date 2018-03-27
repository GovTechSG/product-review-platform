class Agency < Commenter
  include SwaggerDocs::Agency
  include Liker

  has_many :likes, dependent: :destroy, as: :liker
  has_many :comments, dependent: :destroy, as: :commenter
  has_many :grants, dependent: :destroy

  validates :name, :acronym, :kind, :description, presence: true
  validates :name, uniqueness: true
  validates :email, allow_blank: true, email: true
  validates :kind, inclusion: { in: ["Ministry", "Statutory Board", "Agency"],
                                message: "Kind must be any of these: Ministry, Statutory Board, Agency" }
end
