class LinkEntities < ActiveRecord::Migration[5.1]
  def change
    add_reference :products, :company, index: true
    add_foreign_key :products, :companies

    add_reference :services, :company, index: true
    add_foreign_key :services, :companies

    add_reference :reviews, :service, index: true
    add_foreign_key :reviews, :services

    add_reference :reviews, :agency, index: true
    add_foreign_key :reviews, :agencies
  end
end
