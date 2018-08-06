Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "root#index"

  # 仮会員に送られるメールのURLから遷移する際、getメソッドしか使えないため明示的にgetメソッドにしている
  get "users/create", to: "users#create"
  resource :provisional_users, only: %i[new create]
  resource :user_profiles, only: %i[new create]

  # letter_openerのgemを利用するroutingで開発中にrailsから送信されたメールを確認するためのもの
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
