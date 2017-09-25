Rails.application.routes.draw do
  devise_for :managers,
    path: 'manager',
    controllers: { sessions: 'managers/sessions' },
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
    resources :orders, only:[:index, :show, :update]
    resources :categories do
      member do
        get 'change_appearance'
      end
    end
    resources :users, only:[:index, :show]
  end

  root 'store#index', as: 'store'
  resources :line_items, only:[:create, :destroy, :update]
  get :cart, to: 'carts#show'
  resources :orders
  resources :products, only: [:show]
  get 'category/:category', to: 'products#index', as: 'category_products'
  get :cart_items_count, to: "store#get_cart_items_count"
  resources :users, only:[:new, :create]
  resources :user_informations, only:[:new, :create]
  get :update_locale, to: "store#update_locale"

end
