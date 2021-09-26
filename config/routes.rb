Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  namespace :api do
    namespace :v1 do
      resources :schools, only: %i[create update destroy] do
        resources :recipients, only: %i[index create update destroy]
        resources :orders, only: %i[index create update]
      end

      resources :orders do
        resources :items, only: %i[index create update], controller: 'order_items'
      end

      root to: 'docs#index'
    end
  end
end
