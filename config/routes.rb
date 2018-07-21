Rails.application.routes.draw do

  root to: 'root#index'

  resources :provisional_users, only: [:index, :new, :create]

  namespace :users do
    resources :users, only: [:create]
    resources :user_profiles, only: [:new, :create]
  end
end
