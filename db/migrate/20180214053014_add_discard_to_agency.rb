class AddDiscardToAgency < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :discarded_at, :datetime
    add_index :agencies, :discarded_at
  end
end
