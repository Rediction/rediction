namespace :admin do
  # 本ルーティングは
  root to: "home#index"

  # Google OAuth関係のルーティング定義
  post "/login", to: redirect("/admin/auth/google_oauth2"), as: :login
  get "/auth/google_oauth2/callback", to: "sessions#create"

  resource :logout, controller: :sessions, only: %i[destroy]
  resource :dashboard, only: %i[show]
  resources :users, only: %i[index show]
  resources :words, only: %i[index show]
end
