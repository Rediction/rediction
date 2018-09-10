namespace :admin do
  # 本ルーティングは
  root to: "home#index"

  # Google OAuth関係のルーティング定義
  post "/login", to: redirect("/admin/auth/google_oauth2"), as: :login
  get "/auth/google_oauth2/callback", to: "sessions#create"

  resource :logout, controller: :sessions, only: %i[destroy]
  resource :dashboard, only: %i[show]
  resources :words, only: %i[index show destroy]

  namespace :dashboard do
    namespace :ranking do
      resources :users, only: %i[] do
        collection do
          get :favorited_words
          get :favoriting_words
          get :posted_words
          get :followed
          get :following
        end
      end

      resources :words, only: %i[] do
        collection do
          get :favorited
        end
      end
    end

    namespace :transition do
      resources :favorites, only: %i[] do
        collection do
          get :favorite
        end
      end

      resources :follows, only: %i[] do
        collection do
          get :follow
        end
      end

      resources :users, only: %i[] do
        collection do
          get :registered
        end
      end

      resources :words, only: %i[] do
        collection do
          get :posted
        end
      end
    end
  end

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
