class ChangeCommentOwnershipToCommenter < ActiveRecord::Migration[5.1]
  def change
    add_reference :comments, :commentable, polymorphic: true, index: true

    remove_reference :comments, :agency
    add_reference :comments, :commenter, polymorphic: true, index: true
  end
end
