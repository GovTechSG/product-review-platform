ActiveAdmin.register Review do
  permit_params :score, :content, :reviewable_type, :reviewable_id, :company_id

  form do |f|
    f.inputs do
      f.input :score
      f.input :content
      f.input :reviewable_type,
              as: :select,
              collection: ['Product', 'Service']
      f.input :company_id,
              as: :select,
              collection: Company.all.map { |company| [company.name, company.id] }
      f.input :reviewable_id, label: "Product/Service ID"
    end
    f.actions
  end
end
