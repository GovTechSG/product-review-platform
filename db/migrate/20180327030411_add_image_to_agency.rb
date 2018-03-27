class AddImageToAgency < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :image, :string, :null => false, :default => ""
  end
end
