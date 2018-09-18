class AddVendorToReview < ActiveRecord::Migration[5.2]
  def change
    add_reference :reviews, :vendor, foreign_key: {to_table: :companies}
  end
end
