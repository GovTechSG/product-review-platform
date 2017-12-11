class ChangeStarsTypeInReviews < ActiveRecord::Migration[5.1]
  def change
    change_column :reviews, :stars, :float
  end
end
