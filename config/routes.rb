Rails.application.routes.draw do
  require 'sidekiq/web'
  scope ":locale",locale: /#{I18n.available_locales.join("|")}/  do
    devise_for :managers, path: 'manager',
      controllers: { sessions: 'managers/sessions' },
      path_names: { sign_in: 'login', sign_out: 'logout' }
      
    namespace :manager do
      authenticate :manager do
        mount Sidekiq::Web => '/sidekiq'
      end
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
      resources :discounts do
        member do
          get 'change_appearance'
          get 'edit_products'
          put 'update_products'
        end
      end
      get :update_locale, to: "dashboard#update_locale"
    end

    root 'store#index', as: 'store'
    resources :line_items, only:[:create, :destroy, :update]
    resources :products, only: [:show]
    get 'category/:category', to: 'products#index', as: 'category_products'
    get   :cart_items_count, to: "store#get_cart_items_count"

    get   :cart,   to: 'carts#show'
    get   :order,  to: 'orders#new',               as: 'new_order'
    post  :order,  to: 'orders#create',            as: 'orders'
    get   :client, to: 'users#new',                as: 'new_user'
    post  :client, to: 'users#create',             as: 'users'
    get   :info,   to: 'user_informations#new',    as: 'new_user_information'
    post  :info,   to: 'user_informations#create', as: 'user_informations'
  end
  get '*path', to: redirect("/#{I18n.default_locale}/%{path}"), constraints: lambda { |req| !req.path.starts_with? "/#{I18n.default_locale}/" }
  get '', to: redirect("/#{I18n.default_locale}")
end
