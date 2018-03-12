class AddGrantToReview < ActiveRecord::Migration[5.1]
  def change
    add_reference :reviews, :grant, foreign_key: true
  end
end
