class AddFieldsToGrant < ActiveRecord::Migration[5.1]
  def change
    add_column :grants, :acronym, :string, null: false, default: ""
    add_column :grants, :description, :string, null: false, default: ""
    add_reference :grants, :user, foreign_key: true
  end
end
