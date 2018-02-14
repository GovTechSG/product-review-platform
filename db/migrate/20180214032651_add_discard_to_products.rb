class AddDiscardToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :discarded_at, :datetime
    add_index :products, :discarded_at
  end
end
