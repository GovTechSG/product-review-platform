class ChangeColumnConstraintsForMultipleTables < ActiveRecord::Migration[5.2]
  def change
    change_column_null :admin_users, :email, true
    change_column_null :admin_users, :encrypted_password, true
    change_column_null :admin_users, :sign_in_count, true

    change_column_null :agencies, :name, true
    change_column_null :agencies, :kind, true
    change_column_null :agencies, :acronym, true
    change_column_null :agencies, :description, true
    change_column_null :agencies, :image, true


    change_column_null :apps, :encrypted_password, true
    change_column_null :apps, :sign_in_count, true
    change_column_null :apps, :scopes, true
    change_column_null :apps, :confidential, true

    change_column_null :aspects, :name, true
    change_column_null :aspects, :description, true

    change_column_null :comments, :content, true

    change_column_null :companies, :image, true
    change_column_null :companies, :reviews_count, true
    change_column_null :companies, :name, true
    change_column_null :companies, :uen, true
    change_column_null :companies, :aggregate_score, true
    change_column_null :companies, :description, true

    change_column_null :grants, :name, true
    change_column_null :grants, :acronym, true
    change_column_null :grants, :description, true

    change_column_null :industries, :name, true
    change_column_null :industries, :description, true

    change_column_null :products, :name, true
    change_column_null :products, :description, true
    change_column_null :products, :reviews_count, true

    change_column_null :projects, :name, true
    change_column_null :projects, :description, true
    change_column_null :projects, :reviews_count, true

    change_column_null :services, :name, true
    change_column_null :services, :description, true
    change_column_null :services, :reviews_count, true
  end
end
