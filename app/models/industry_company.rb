class IndustryCompany < ApplicationRecord
  belongs_to :company
  belongs_to :industry

  scope :kept, -> { undiscarded.joins(:company).merge(Company.kept) }
  scope :kept, -> { undiscarded.joins(:industry).merge(Industry.kept) }
end
