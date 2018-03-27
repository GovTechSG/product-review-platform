class AddImageToCompany < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :image, :string, :null => false, :default => ""
  end
end
