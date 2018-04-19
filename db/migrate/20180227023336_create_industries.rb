class CreateIndustries < ActiveRecord::Migration[5.1]
  def change
    create_table :industries do |t|
      t.string :name, :null => false, :default => ""
      t.datetime :discarded_at
      t.index :discarded_at
      t.index :name, :unique => true
      
      t.timestamps
    end
  end
end
