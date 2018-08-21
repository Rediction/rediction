Rails.application.routes.draw do
  # namespaceで区切られているものはroutesフォルダーに切り分けて、routes.rbが膨らまないようにする。
  def draw(name)
    instance_eval(File.read(Rails.root.join("config/routes/#{name}.rb")))
  end

  # APP側とAPI側でWords一覧の種類が被っているので、concernで切り出している。
  concern :words_index do
    collection do
      get "index_latest_order"
      get "index_random_order"
      get "index_scoped_favorite_words"
      get "index_scoped_follow_users"
      get "search"
    end
  end

  draw :admin
  draw :api

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "root#index"

  resources :words, only: %i[new create show destroy], concerns: :words_index

  resources :users, only: %i[show] do
    scope module: :users do
      resources :favorites, only: %i[index]
    end
  end

  # お問い合わせフォームの実装
  get "contact", to: "contact#index"

  # 仮会員に送られるメールのURLから遷移する際、getメソッドしか使えないため明示的にgetメソッドにしている
  get "users/create", to: "users#create"
  resource :provisional_users, only: %i[new create]
  resource :user_profile, only: %i[new create edit update]

  # ログイン・ログアウト処理に使うルーティング
  resource :login, only: %i[new create], controller: :sessions, path_names: {new: ""}
  resource :logout, controller: :sessions, only: %i[destroy]

  namespace :user do
    resource :mypage, only: %i[show]
    resource :password_reissue_token, only: %i[new create]
    resource :password_reissue, only: %i[new create]
  end

  # letter_openerのgemを利用するroutingで開発中にrailsから送信されたメールを確認するためのもの
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # いずれのルーティング定義にも当てはまらない場合にエラー画面を表示
  get "*not_found", to: "exceptions#routing_error" unless Rails.env.development?
end
