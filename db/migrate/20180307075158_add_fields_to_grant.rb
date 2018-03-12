class AddFieldsToGrant < ActiveRecord::Migration[5.1]
  def change
    add_column :grants, :acronym, :string
    add_column :grants, :description, :string
    add_reference :grants, :user, foreign_key: true
  end
end
