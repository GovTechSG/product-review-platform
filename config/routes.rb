Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  scope :api do
    scope :v1 do
      devise_for :apps, skip: [:sessions]
      use_doorkeeper do
        skip_controllers :authorizations, :applications,
                         :authorized_applications, :token_info
        as tokens: 'sign_in'
        controllers tokens: 'tokens'
      end
      get '/statistics', to: 'statistics#index'
      get '/companies/:company_id/clients', to: 'companies#clients', as: 'companies_clients'
      get '/companies/:company_id/offerings', to: 'companies#offerings', as: 'companies_offerings'
      post '/oauth/refresh', to: 'tokens#refresh'
      post '/project/project_name', to: 'projects#search', as: 'search_project'
      post '/service/service_name', to: 'services#search', as: 'search_service'
      post '/product/product_name', to: 'products#search', as: 'search_product'
      post '/company/company_uen', to: 'companies#search', as: 'search_company'
      get '/grant/grant_name', to: 'grants#search', as: 'search_grant'
      # Mount custom routes, removing view-only routes e.g. /new, /cancel

      shallow do
        resources :companies do
          resources :grants, only: [:index]
          resources :products do
            resources :reviews do
              resources :comments
              resources :likes, only: [:index, :show, :create, :destroy]
            end
          end

          resources :services do
            resources :reviews do
              resources :comments
              resources :likes, only: [:index, :show, :create, :destroy]
            end
          end

          resources :projects do
            resources :reviews do
              resources :comments
              resources :likes, only: [:index, :show, :create, :destroy]
            end
          end
        end
      end
      resources :grants
      resources :industries
      resources :agencies
      resources :aspects
    end
  end

  resources :apidocs, only: [:index]
  root to: 'swagger_ui#index'
  get 'api/docs', to: 'swagger_ui#apidoc'

  get 'api/json', to: 'apidocs#index'
end
