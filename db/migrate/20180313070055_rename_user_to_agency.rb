class RenameUserToAgency < ActiveRecord::Migration[5.1]
  def change
    rename_table :users, :agencies
    remove_foreign_key :likes, :agencies
    remove_foreign_key :grants, :agencies
    remove_foreign_key :comments, :agencies
    rename_column      :comments, :user_id, :agency_id
    rename_column      :likes, :user_id, :agency_id
    rename_column      :grants, :user_id, :agency_id
    add_foreign_key    :likes, :agencies
    add_foreign_key    :comments, :agencies
    add_foreign_key    :grants, :agencies
  end
end
