class ChangeReviewOwnershipToReviewer < ActiveRecord::Migration[5.1]
  def change
    remove_reference :reviews, :company
    add_reference :reviews, :reviewer, polymorphic: true, index: true
  end
end
