ActiveAdmin.register Like do
  permit_params :agency_id, :review_id

  form do |f|
    f.inputs do
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
