class MakeUenUniqueFalse < ActiveRecord::Migration[5.2]
  def change
    remove_index :companies, :uen
    add_index :companies, :uen
  end
end
