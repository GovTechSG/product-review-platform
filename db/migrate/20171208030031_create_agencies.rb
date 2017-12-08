class CreateAgencies < ActiveRecord::Migration[5.1]
  def change
    create_table :agencies do |t|
      t.string :name, :null => false, :default => ""
      t.string :email, :null => false, :default => ""
      t.string :number, :null => false, :default => ""

      t.timestamps
    end
  end
end
