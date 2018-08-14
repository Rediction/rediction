namespace :admin do
  # 本ルーティングは
  root to: "home#index"

  # Google OAuth関係のルーティング定義
  post "/login", to: redirect("/admin/auth/google_oauth2"), as: :login
  get "/auth/google_oauth2/callback", to: "sessions#create"

  resource :logout, controller: :sessions, only: %i[destroy]
  resource :dashboard, only: %i[show]
  resources :words, only: %i[index show]

  namespace :user, as: "users" do
    namespace :resignation do
      resources :requests, only: %i[index]
    end
  end

  resources :users, only: %i[index show] do
    scope module: :user do
      resources :freezed_reasons, only: %i[new create]
      resources :unfreezed_reasons, only: %i[new create]

      namespace :resignation do
        resources :requests, only: %i[new create]
        resources :request_cancels, only: %i[new create]
      end
    end
  end
end
