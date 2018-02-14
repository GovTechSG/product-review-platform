class AddDiscardToApp < ActiveRecord::Migration[5.1]
  def change
    add_column :apps, :discarded_at, :datetime
    add_index :apps, :discarded_at
  end
end
