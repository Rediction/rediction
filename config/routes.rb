Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'root#index'
  resources :timelines, only: [:index]
  resources :words, only: [:new, :create, :destroy]
end
