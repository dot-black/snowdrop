Rails.application.routes.draw do

  resources :line_items
  resources :carts
  resources :orders
  resources :products, only: [:index, :show]

  devise_for :managers, path: 'manager', controllers: { sessions: 'managers/sessions' },
      path_names: { sign_in: 'login', sign_out: 'logout' }

  namespace :manager do
    # mount Sidekiq::Web => '/sidekiq'
    root 'dashboard#index'
    get :dashboard, to: 'dashboard#index'
    resources :products
    resources :orders
  end

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'store#index', as: 'store'
end
