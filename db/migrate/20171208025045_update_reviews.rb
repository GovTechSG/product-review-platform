class UpdateReviews < ActiveRecord::Migration[5.1]
  def change
    rename_column :reviews, :stars, :score
    change_column :reviews, :score, :integer, :null => false, :default => 0

    rename_column :reviews, :comment, :content
    change_column :reviews, :content, :text, :null => false, :default => ""
  end
end
