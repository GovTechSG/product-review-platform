class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.integer :score, :null => false, :default => 0
      t.text :content, :null => false, :default => ""
      t.references :product, foreign_key: true
      t.references :service, foreign_key: true
      t.references :agency, foreign_key: true

      t.timestamps
    end
  end
end
