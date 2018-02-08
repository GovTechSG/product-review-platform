ActiveAdmin.register Comment, as: 'ReviewComment' do
  permit_params :content, :agency_id, :review_id

  form do |f|
    f.inputs do
      f.input :content
      f.input :agency_id,
              as: :select,
              collection: Agency.all.map { |agency| [agency.name, agency.id] }
      f.input :review_id,
              as: :select,
              collection: Review.all.map { |review| [review.content, review.id] }
    end
    f.actions
  end
end
