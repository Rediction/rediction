Rails.application.routes.draw do


  get 'users/index'

  get 'users/new' => 'users#new'

  post 'users/create' => 'users#create'

  # resources :users



end
