class RenameUsersForeignKeys < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :likes, :users
    remove_foreign_key :comments, :users
    rename_column      :comments, :agency_id, :user_id
    rename_column      :likes, :agency_id, :user_id
    add_foreign_key    :likes, :users
    add_foreign_key    :comments, :users
  end
end
