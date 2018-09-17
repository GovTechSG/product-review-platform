class MakeVendorReviewableManyToMany < ActiveRecord::Migration[5.2]
  def change
    remove_column :products, :company_id
    remove_column :projects, :company_id
    remove_column :services, :company_id
    create_table :company_reviewables do |t|
      t.belongs_to :company, foreign_key: true
      t.references :reviewable, polymorphic: true, index: true

      t.datetime :discarded_at
      t.index :discarded_at

      t.timestamps
    end
  end
end
