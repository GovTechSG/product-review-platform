class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :name, :null => false, :default => ""
      t.string :UEN, :null => false, :default => ""
      t.decimal :aggregate_score, :null => false, :default => 0

      t.index :UEN, :unique => true
      t.index :name, :unique => true

      t.timestamps
    end
  end
end
