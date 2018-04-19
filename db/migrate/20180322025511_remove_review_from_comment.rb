class RemoveReviewFromComment < ActiveRecord::Migration[5.1]
  def change
    remove_reference :comments, :review
  end
end
