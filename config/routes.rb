Rails.application.routes.draw do
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

    post "/auth/confirmation", to: "devise_token_auth/confirmations#create"
  end

  shallow do
    resources :companies do
      resources :products do
        resources :reviews do
          resources :comments
        end
      end

      resources :services do
        resources :reviews do
          resources :comments
        end
      end
    end
  end

  resources :agencies
end
