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
end
