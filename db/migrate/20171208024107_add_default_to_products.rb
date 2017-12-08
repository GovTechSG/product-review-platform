class AddDefaultToProducts < ActiveRecord::Migration[5.1]
  def change
    change_column :products, :name, :string, :null => false, :default => ""
  end
end
