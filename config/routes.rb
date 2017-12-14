Rails.application.routes.draw do
  resources :companies do
    resources :products, only: [:index] do
      resources :reviews, only: [:index] do
        resources :comments, only: [:index]
      end
    end

    resources :services, only: [:index] do
      resources :reviews, only: [:index] do
        resources :comments, only: [:index]
      end
    end
  end
  resources :products, only: [:show, :create, :update, :destroy]
  resources :services, only: [:show, :create, :update, :destroy]
  resources :reviews, only: [:show, :create, :update, :destroy]
  resources :comments, only: [:show, :create, :update, :destroy]

  resources :agencies
end
