class CreateIndustryCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :industry_companies do |t|
      t.belongs_to :company, foreign_key: true
      t.belongs_to :industry, foreign_key: true

      t.datetime :discarded_at
      t.index :discarded_at

      t.timestamps
    end
  end
end
