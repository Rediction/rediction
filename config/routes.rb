Rails.application.routes.draw do
  root to: 'root#index'

  get 'user_profiles/creation', to: 'user_profiles#creation'
  get 'provisional_users/creation', to: 'provisional_users#creation'
  resources :provisional_users, only: [:index, :new, :create]
  resource :user, only: [:create]
  resources :user_profiles, only: [:new, :create]

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
