class RenameAspectReviewColumn < ActiveRecord::Migration[5.1]
  def change
    rename_column :aspect_reviews, :strength_id, :aspect_id
  end
end
