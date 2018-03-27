class ChangeLikeOwnershipToLiker < ActiveRecord::Migration[5.1]
  def change
    remove_reference :likes, :review
    add_reference :likes, :likeable, polymorphic: true, index: true

    remove_reference :likes, :agency
    add_reference :likes, :liker, polymorphic: true, index: true
  end
end
