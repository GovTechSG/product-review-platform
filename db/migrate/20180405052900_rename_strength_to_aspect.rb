class RenameStrengthToAspect < ActiveRecord::Migration[5.1]
  def change
    rename_table :strengths, :aspects do |t|
      t.string :name, :null => false, :default => ""
      t.string :description, :null => false, :default => ""
      t.datetime :discarded_at
      t.index :discarded_at
      t.timestamps
    end

    rename_table :strength_reviews, :aspect_reviews do |t|
      t.belongs_to :strength, foreign_key: true
      t.belongs_to :review, foreign_key: true

      t.datetime :discarded_at
      t.index :discarded_at

      t.timestamps
    end
  end
end
