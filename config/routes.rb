Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
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
