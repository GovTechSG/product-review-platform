class RenameAgencyToUser < ActiveRecord::Migration[5.1]
  def change
    rename_table :agencies, :users
  end
end
