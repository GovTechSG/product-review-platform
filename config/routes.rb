Rails.application.routes.draw do
  devise_for :apps
  use_doorkeeper
  get '/statistics', to: 'statistics#index'
  # Mount custom routes, removing view-only routes e.g. /new, /cancel

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
