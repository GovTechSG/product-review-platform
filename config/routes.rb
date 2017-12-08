Rails.application.routes.draw do
  resources :services
  resources :companies
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users

  resources :products

  resources :reviews
end
