class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :UEN
      t.decimal :aggregate_score

      t.timestamps
    end
  end
end
