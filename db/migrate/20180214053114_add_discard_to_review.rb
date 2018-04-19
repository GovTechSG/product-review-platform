class AddDiscardToReview < ActiveRecord::Migration[5.1]
  def change
    add_column :reviews, :discarded_at, :datetime
    add_index :reviews, :discarded_at
  end
end
