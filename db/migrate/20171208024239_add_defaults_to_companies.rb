class AddDefaultsToCompanies < ActiveRecord::Migration[5.1]
  def change
    change_column :companies, :name, :string, :null => false, :default => ""
    change_column :companies, :UEN, :string, :null => false, :default => ""
    change_column :companies, :aggregate_score, :decimal, :null => false, :default => 0
  end
end
