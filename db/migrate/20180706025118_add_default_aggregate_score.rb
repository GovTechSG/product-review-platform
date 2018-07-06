class AddDefaultAggregateScore < ActiveRecord::Migration[5.2]
  def change
    change_column_default :companies, :aggregate_score, 0
    change_column_default :products, :aggregate_score, 0
    change_column_default :services, :aggregate_score, 0
    change_column_default :projects, :aggregate_score, 0
  end
end
