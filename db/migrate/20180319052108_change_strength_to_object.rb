class ChangeStrengthToObject < ActiveRecord::Migration[5.1]
  def change
    remove_index :reviews, :strengths
    remove_column :reviews, :strengths, :string, array: true
  end
end
