class AddAgencyAndReviewIndexToLikes < ActiveRecord::Migration[5.1]
  def change
    add_index :likes, [:agency_id, :review_id], unique: true
  end
end
