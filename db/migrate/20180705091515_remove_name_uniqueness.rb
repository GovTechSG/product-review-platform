class RemoveNameUniqueness < ActiveRecord::Migration[5.2]
  def change
    remove_index :companies, :name
    add_index :companies, :name
  end
end
