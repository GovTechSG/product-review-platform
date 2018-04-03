require "letter_avatar/has_avatar"

class Agency < Commenter
  include SwaggerDocs::Agency
  include LetterAvatar::HasAvatar
  include Imageable
  include Liker
  include Commenter
  mount_uploader :image, ImageUploader

  has_many :likes, dependent: :destroy, as: :liker
  has_many :comments, dependent: :destroy, as: :commenter
  has_many :grants, dependent: :destroy

  validates :name, :acronym, :kind, :description, presence: true
  validates :name, uniqueness: true
  validates :email, allow_blank: true, email: true
  validates :image, file_size: { less_than: 1.megabytes }
  validates :kind, inclusion: { in: ["Ministry", "Statutory Board", "Agency"],
                                message: "Kind must be any of these: Ministry, Statutory Board, Agency" }
end
