Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'admin/create'
    end
  end
  mount_devise_token_auth_for 'User', at: 'auth'
  namespace :api do
    namespace :v1 do
      resources :articles, only: [:index, :show]
      namespace :admin do
        resources :articles, only: [:create]
      end
    end
  end
end
