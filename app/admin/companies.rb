ActiveAdmin.register Company do
  permit_params :name, :UEN, :aggregate_score, :description

  form do |f|
    f.inputs do
      f.input :name
      f.input :UEN
      f.input :aggregate_score
      f.input :description
    end
    f.actions
  end
end
