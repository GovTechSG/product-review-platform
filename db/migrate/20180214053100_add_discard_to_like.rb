class AddDiscardToLike < ActiveRecord::Migration[5.1]
  def change
    add_column :likes, :discarded_at, :datetime
    add_index :likes, :discarded_at
  end
end
