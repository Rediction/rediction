class ApplicationController < ActionController::Base
  before_action :basic_authentication if ENV['BASIC_AUTH_USERNAME'].present? && ENV['BASIC_AUTH_PASSWORD'].present?
  before_action :authenticate

    # ログイン処理を行うメソッド
    def log_in(user)
      session[:user_id] = user.id
      UserAuthLog.create_success_log(user)
    end

    # ユーザーがログインをしているか確かめるメソッド
    def logged_in?
      session[:user_id].present?
    end

    # ユーザー認証を行うメソッド
    def authenticate
      # TODO (Shuji Ota) : ログインページが出来次第、リダイレクト先をログインページに変更する。
      redirect_to root_path, flash: { error: "ログインしてください。"} unless logged_in?
    end

  private

    # Basic認証
    def basic_authentication
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV['BASIC_AUTH_USERNAME'] && password == ENV['BASIC_AUTH_PASSWORD']
      end
    end
end
