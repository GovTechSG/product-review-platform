ActiveAdmin.register Doorkeeper::AccessToken, as: 'AccessToken' do
  actions :all, except: [:create, :edit, :new]
  index do
    selectable_column
    id_column
    column "App" do |m|
      App.find(m.resource_owner_id).name
    end

    column :created_at
    column :revoked_at
    actions
  end

  filter :resource_owner_id
  filter :created_at

  controller do
    resources_configuration[:self][:instance_name] = 'AccessToken'
    actions :all, except: [:edit, :create]

    def destroy(options = {}, &block)
      object = resource
      options[:location] ||= smart_collection_url

      object.revoke
      respond_with_dual_blocks(object, options, &block)
    end
  end
end
