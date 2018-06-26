class AddScoreToReviewables < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :aggregate_score, :decimal
    add_column :services, :aggregate_score, :decimal
    add_column :projects, :aggregate_score, :decimal
  end
end
