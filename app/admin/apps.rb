ActiveAdmin.register App do
  permit_params :name, :password, :password_confirmation, :description

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :name
  filter :description
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  controller do
    def update
      if params[:app][:password].blank?
        params[:app].delete("password")
        params[:app].delete("password_confirmation")
      end
      if params[:app][:email].blank?
        params[:app].delete("email")
        params[:app].delete("email_confirmation")
      end
      super
    end

    def destroy(options = {}, &block)
      object = resource
      options[:location] ||= smart_collection_url

      object.discard
      respond_with_dual_blocks(object, options, &block)
    end
  end
end
