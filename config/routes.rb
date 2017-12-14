Rails.application.routes.draw do
  shallow do
    resources :companies do
      resources :products do
        resources :reviews do
          resources :comments
        end
      end

      resources :services, only: [:index] do
        resources :reviews, only: [:index] do
          resources :comments, only: [:index]
        end
      end
    end
  end

  resources :agencies
end
