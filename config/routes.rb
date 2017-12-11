Rails.application.routes.draw do
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
  resources :agencies
end
