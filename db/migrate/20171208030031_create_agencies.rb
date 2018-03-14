class CreateAgencies < ActiveRecord::Migration[5.1]
  def change
    create_table :agencies do |t|
      t.string :name, :null => false, :default => ""
      t.string :email
      t.string :number

      t.index :name, :unique => true

      t.timestamps
    end
  end
end
