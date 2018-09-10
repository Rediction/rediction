class ApplicationController < ActionController::Base
  include ExceptionHandlers unless Rails.env.development?
  include SessionHelper

  protect_from_forgery with: :exception
  before_action :basic_authentication if ENV['BASIC_AUTH_USERNAME'].present? && ENV['BASIC_AUTH_PASSWORD'].present?
  before_action :authenticate
  before_action :update_permanent_auth_token

  # ユーザー認証を行うメソッド
  def authenticate
    # 未ログイン時はログイン画面へリダイレクト
    return redirect_to new_login_path, flash: { error: "ログインしてください。"} unless logged_in?

    # プロフィール登録が必要な場合は、プロフィール登録画面へリダイレクト
    redirect_to new_user_profile_path if require_redirecting_to_new_profile?
  end

  # 永続認証用のトークンを更新
  def update_permanent_auth_token
    update_remember_token if require_token_update?
  end

  # 認証ユーザーのベースページへのリダイレクト
  def redirect_authed_user_base_page
    redirect_to index_scoped_follow_users_words_path
  end

  # lograge用のメソッド
  # user_idはAPI, Adminなどで取得方法が異なるため、Controllerごとにpayloadに格納している。
  def append_info_to_payload(payload)
    super
    payload[:user_id] = current_user&.id
  end

  private

  # Basic認証
  def basic_authentication
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['BASIC_AUTH_USERNAME'] && password == ENV['BASIC_AUTH_PASSWORD']
    end
  end

  # プロフィール登録画面へのリダイレクトが必要かどうかの判定
  # プロフィール未登録 && プロフィール登録ページにいない場合
  def require_redirecting_to_new_profile?
    current_user.profile.blank? && !(controller_name == "user_profiles" && ["new", "create"].include?(action_name))
  end
end
