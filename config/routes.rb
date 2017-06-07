Rails.application.routes.draw do
  devise_for :managers, path: 'manager', controllers: { sessions: 'managers/sessions' },
      path_names: { sign_in: 'login', sign_out: 'logout' }

  namespace :manager do
    # mount Sidekiq::Web => '/sidekiq'
    root 'dashboard#index'
    get :dashboard, to: 'dashboard#index'

    resources :products do
      member do
        get 'change_appearance'
        get 'archive'
        get 'remove_single_image'
      end
      collection do
        get :archival
      end
    end
    resources :orders
  end

  devise_for :users

  resources :line_items
  resources :carts
  resources :orders
  resources :products, only: [:index, :show]


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'store#index', as: 'store'
end
