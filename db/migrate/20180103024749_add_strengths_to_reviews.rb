class AddStrengthsToReviews < ActiveRecord::Migration[5.1]
  def change
    add_column :reviews, :aspects, :string, array: true, default: []
    add_index :reviews, :aspects, using: 'gin'
  end
end
