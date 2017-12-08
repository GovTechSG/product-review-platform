class MakeUenUnique < ActiveRecord::Migration[5.1]
  def change
    add_index :companies, :UEN, unique: true
  end
end
