Rails.application.routes.draw do
  # namespaceで区切られているものはroutesフォルダーに切り分けて、routes.rbが膨らまないようにする。
  def draw(name)
    instance_eval(File.read(Rails.root.join("config/routes/#{name}.rb")))
  end

  draw :admin

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "root#index"

  resources :words, only: %i[index, new, create, destroy]

  # 仮会員に送られるメールのURLから遷移する際、getメソッドしか使えないため明示的にgetメソッドにしている
  get "users/create", to: "users#create"
  resource :provisional_users, only: %i[new create]
  resource :user_profiles, only: %i[new create]

  # ログイン・ログアウト処理に使うルーティング
  resource :login, only: %i[new create], controller: :sessions, path_names: {new: ""}
  resource :logout, controller: :sessions, only: %i[destroy]

  # letter_openerのgemを利用するroutingで開発中にrailsから送信されたメールを確認するためのもの
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # いずれのルーティング定義にも当てはまらない場合にエラー画面を表示
  get "*not_found", to: "exceptions#routing_error" unless Rails.env.development?
end
