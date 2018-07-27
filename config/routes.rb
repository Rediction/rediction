Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'root#index'
  resource :provisional_users, only: [:new, :create]
  resource :user_profiles, only: [:new, :create]
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
