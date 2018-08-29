class ApplicationController < ActionController::Base
  include ExceptionHandlers unless Rails.env.development?

  protect_from_forgery with: :exception
  before_action :basic_authentication if ENV['BASIC_AUTH_USERNAME'].present? && ENV['BASIC_AUTH_PASSWORD'].present?
  before_action :authenticate
  helper_method :logged_in?, :current_user

  # ログイン処理を行うメソッド
  def log_in(user)
    session[:user_id] = user.id
    UserAuthLog.create_success_log(user)
  end

  # ユーザーがログインをしているか確かめるメソッド
  def logged_in?
    current_user.present?
  end

  # ユーザー認証を行うメソッド
  def authenticate
    # 未ログイン時はログイン画面へリダイレクト
    return redirect_to new_login_path, flash: { error: "ログインしてください。"} unless logged_in?

    # プロフィール登録が必要な場合は、プロフィール登録画面へリダイレクト
    redirect_to new_user_profile_path if require_redirecting_to_new_profile?
  end

  # sessionのuser_idを削除するメソッド
  def log_out
    session[:user_id] = nil
  end

  # 認証ユーザーのベースページへのリダイレクト
  def redirect_authed_user_base_page
    redirect_to index_scoped_follow_users_words_path
  end

  private

    # ログイン中のユーザーのインスタンスを生成するメソッド(稼働中のもの)
    def current_user
      @current_user ||= User.active.find_by(id: session[:user_id])
    end

    # プロフィール登録画面へのリダイレクトが必要かどうかの判定
    # プロフィール未登録 && プロフィール登録ページにいない場合
    def require_redirecting_to_new_profile?
      current_user.profile.blank? && \
        !(controller_name == "user_profiles" && (action_name == "new" || action_name == "create"))
    end

    # Basic認証
    def basic_authentication
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV['BASIC_AUTH_USERNAME'] && password == ENV['BASIC_AUTH_PASSWORD']
      end
    end
end
