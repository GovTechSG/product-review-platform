class AddConfidentialToDoorkeeperApplication < ActiveRecord::Migration[5.2]
  def change
    add_column(
      :apps,
      :confidential,
      :boolean,
      null: false,
      default: true # maintaining backwards compatibility: require secrets
    )
  end
end
