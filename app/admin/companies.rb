ActiveAdmin.register Company do
  permit_params :name, :uen, :aggregate_score, :description

  form do |f|
    f.inputs do
      f.input :name
      f.input :uen
      f.input :aggregate_score
      f.input :description
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
