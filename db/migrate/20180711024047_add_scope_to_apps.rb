class AddScopeToApps < ActiveRecord::Migration[5.2]
  def change
    add_column :apps, :scopes, :string, array: true, :null => false, :default => ['read_only']
  end
end
