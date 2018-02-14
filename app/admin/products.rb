ActiveAdmin.register Product do
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

  controller do
    def destroy(options = {}, &block)
      object = resource
      options[:location] ||= smart_collection_url

      object.discard
      respond_with_dual_blocks(object, options, &block)
    end
  end
end
