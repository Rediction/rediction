Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'root#index'

  resources :provisional_users, only: :new, :create, :destroy
  resources :users
  resources :user_profiles
end
