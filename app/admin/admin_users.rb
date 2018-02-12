ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
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
  end
end
