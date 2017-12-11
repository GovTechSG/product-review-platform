class CreateServices < ActiveRecord::Migration[5.1]
  def change
    create_table :services do |t|
      t.string :name, :null => false, :default => ""
      t.string :description, :null => false, :default => ""
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end