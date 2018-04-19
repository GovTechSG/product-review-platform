class AddDescriptionToIndustry < ActiveRecord::Migration[5.1]
  def change
    add_column :industries, :description, :string, null: false, default: ""
  end
end
