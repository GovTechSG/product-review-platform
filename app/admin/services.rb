ActiveAdmin.register Service do
  permit_params :name, :description, :company_id

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :company_id,
              as: :select,
              collection: Company.all.map { |company| [company.name, company.id] }
    end
    f.actions
  end
end
