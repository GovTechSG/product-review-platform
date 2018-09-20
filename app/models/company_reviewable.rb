class CompanyReviewable < ApplicationRecord
  belongs_to :company
  belongs_to :reviewable, polymorphic: true
end
