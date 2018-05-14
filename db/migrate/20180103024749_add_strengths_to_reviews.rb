class AddStrengthsToReviews < ActiveRecord::Migration[5.1]
  def change
    add_column :reviews, :strengths, :string, array: true, default: []
    add_index :reviews, :strengths, using: 'gin'
  end
end
