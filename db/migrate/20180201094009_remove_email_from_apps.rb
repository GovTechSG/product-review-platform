class RemoveEmailFromApps < ActiveRecord::Migration[5.1]
  def change
    remove_column :apps, :email, :string
  end
end
