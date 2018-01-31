Rails.application.routes.draw do
  get '/statistics', to: 'statistics#index'
  mount_devise_token_auth_for 'User', at: 'auth', skip: [:sessions, :passwords, :registrations, :confirmations]
  # Mount custom routes, removing view-only routes e.g. /new, /cancel
  devise_scope :user do
    post "/auth/sign_in", to: "devise_token_auth/sessions#create"
    delete "/auth/sign_in", to: "devise_token_auth/sessions#destroy"

    post "/auth/password", to: "devise_token_auth/passwords#create"
    patch "/auth/password", to: "devise_token_auth/passwords#update"

    post "/auth", to: "devise_token_auth/registrations#create"
    patch "/auth", to: "devise_token_auth/registrations#update"
    delete "/auth", to: "devise_token_auth/registrations#destroy"

  end

  shallow do
    resources :companies do
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
    end
  end

  resources :agencies

  resources :apidocs, only: [:index]
end
