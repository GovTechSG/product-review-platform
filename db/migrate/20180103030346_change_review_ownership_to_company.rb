class ChangeReviewOwnershipToCompany < ActiveRecord::Migration[5.1]
  def change
    remove_reference :reviews, :agency
    add_reference :reviews, :company, foreign_key: true
  end
end
