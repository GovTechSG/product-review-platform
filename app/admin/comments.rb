ActiveAdmin.register Comment, as: 'ReviewComment' do
  permit_params :content, :user_id, :review_id

  form do |f|
    f.inputs do
      f.input :content
      f.input :user_id,
              as: :select,
              collection: User.all.map { |user| [user.name, user.id] }
      f.input :review_id,
              as: :select,
              collection: Review.all.map { |review| [review.content, review.id] }
    end
    f.actions
  end

  controller do
    def destroy(options = {}, &block)
      object = resource
      options[:location] ||= smart_collection_url

      object.discard
      respond_with_dual_blocks(object, options, &block)
    end
  end
end
