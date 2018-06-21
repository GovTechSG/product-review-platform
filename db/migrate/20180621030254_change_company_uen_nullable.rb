class ChangeCompanyUenNullable < ActiveRecord::Migration[5.2]
  def change
    change_column_null :companies, :uen, true
  end
end
