ActiveAdmin.register Doorkeeper::AccessToken do
  index do
    selectable_column
    id_column
    column "App" do |m|
      App.find(m.resource_owner_id).name
    end

    column :created_at
    actions
  end

  filter :resource_owner_id
  filter :created_at

  controller do
    resources_configuration[:self][:instance_name] = 'AccessToken'
    actions :all, except: [:edit, :create]
  end
end
