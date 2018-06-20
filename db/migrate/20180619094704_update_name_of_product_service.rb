class UpdateNameOfProductService < ActiveRecord::Migration[5.2]
  def change
    add_index :products, :name, unique: true
    add_index :services, :name, unique: true
  end
end
