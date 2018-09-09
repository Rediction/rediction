class Admin::ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate
  before_action :admin_basic_authentication
  layout "admin"

  helper_method :current_admin_user, :logged_in?

  # ログイン処理
  def log_in(admin_user)
    session[:admin_user_id] = admin_user.id
  end

  # ログアウト処理
  def log_out
    session[:admin_user_id] = nil
  end

  # ActiveRecordをSQLに直して実行する処理
  def excute_sql(active_record)
    con = ActiveRecord::Base.connection
    result = con.select_all(active_record.to_sql)
    result.to_hash
  end

  # lograge用のメソッド
  # user_idはAPI, Adminなどで取得方法が異なるため、Controllerごとにpayloadに格納している。
  def append_info_to_payload(payload)
    super
    payload[:user_id] = current_admin_user&.id
  end

  private

  # 管理者用の認証処理
  def authenticate
    redirect_to admin_root_path, flash: { error: "ログインしてください。" } unless logged_in?
  end

  # ログイン中の管理者ユーザーのインスタンス
  def current_admin_user
    @current_admin_user ||= Admin::User.find_by(id: session[:admin_user_id])
  end

  # ログイン中かどうかの判定
  def logged_in?
    current_admin_user.present?
  end

  # 管理画面用のBasic認証が設定されているかを判定
  def admin_basic_authentication_setted?
    ENV["ADMIN_BASIC_AUTH_USERNAME"].present? && ENV["ADMIN_BASIC_AUTH_PASSWORD"].present?
  end

  # 管理画面用のBasic認証
  def admin_basic_authentication
    if admin_basic_authentication_setted?
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV["ADMIN_BASIC_AUTH_USERNAME"] && password == ENV["ADMIN_BASIC_AUTH_PASSWORD"]
      end
    end
  end
end
