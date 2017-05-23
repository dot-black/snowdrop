Rails.application.routes.draw do

  resources :line_items
  resources :carts
  resources :orders
  resources :products
  devise_for :managers
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'store#index', as: 'store'
end
