class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :name, :null => false, :default => ""
      t.string :uen, :null => false, :default => ""
      t.string :phone_number
      t.string :url
      t.decimal :aggregate_score, :null => false, :default => 0

      t.index :uen, :unique => true
      t.index :name, :unique => true

      t.timestamps
    end
  end
end
