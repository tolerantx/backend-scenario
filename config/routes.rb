Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  namespace :api do
    namespace :v1 do
      resources :schools, only: %i[create update destroy] do
        resources :recipients, only: %i[index create]
        resources :orders, only: %i[index create]
      end

      resources :orders, only: :update do 
        get :items, to: 'order_items#index'
        post :items, to: 'order_items#create'
      end

      resources :recipients, only: %i[update destroy]
      resources :order_items, only: %i[update destroy]

      root to: 'docs#index'
    end
  end
end
