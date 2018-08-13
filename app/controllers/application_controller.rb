class ApplicationController < ActionController::Base
  before_action :basic_authentication if ENV['BASIC_AUTH_USERNAME'].present? && ENV['BASIC_AUTH_PASSWORD'].present?
  before_action :authenticate
  before_action :current_user
  helper_method :logged_in?

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
    redirect_to new_login_path, flash: { error: "ログインしてください。"} unless logged_in?
  end

  # sessionのuser_idを削除するメソッド
  def log_out
    session[:user_id] = nil
  end

  # ログイン中のユーザーを定義するメソッド
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  private

    # Basic認証
    def basic_authentication
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV['BASIC_AUTH_USERNAME'] && password == ENV['BASIC_AUTH_PASSWORD']
      end
    end
end
