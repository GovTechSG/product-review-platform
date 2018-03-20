class CreateAgencies < ActiveRecord::Migration[5.1]
  def change
    create_table :agencies do |t|
      t.string :name, :null => false, :default => ""
      t.string :kind, :null => false, :default => ""
      t.string :acronym, :null => false, :default => ""
      t.string :description, :null => false, :default => ""
      t.string :email
      t.string :phone_number

      t.index :name, :unique => true

      t.timestamps
    end
  end
end
