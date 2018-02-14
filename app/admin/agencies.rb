ActiveAdmin.register Agency do
  permit_params :name, :email, :number

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :number
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
