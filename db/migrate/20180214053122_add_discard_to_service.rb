class AddDiscardToService < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :discarded_at, :datetime
    add_index :services, :discarded_at
  end
end
