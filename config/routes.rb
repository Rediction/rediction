Rails.application.routes.draw do
  root to: 'root#index'


  get 'provisional_users/creation', to: 'provisional_users#creation'
  get 'users/index', to: 'users#index'
  resources :provisional_users, only: [:new, :create]
  resource :user, only: [:create]
  resources :user_profiles, only: [:new, :create]

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
