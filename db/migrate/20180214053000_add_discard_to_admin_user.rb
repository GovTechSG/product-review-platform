class AddDiscardToAdminUser < ActiveRecord::Migration[5.1]
  def change
    add_column :admin_users, :discarded_at, :datetime
    add_index :admin_users, :discarded_at
  end
end
