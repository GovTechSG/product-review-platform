class CreateStrengthReview < ActiveRecord::Migration[5.1]
  def change
    create_table :strength_reviews do |t|
      t.belongs_to :strength, foreign_key: true
      t.belongs_to :review, foreign_key: true

      t.datetime :discarded_at
      t.index :discarded_at

      t.timestamps
    end
  end
end
