# # 永続認証(Remember Me機能)について
# 現状はログインした際、すべての認証を永続認証としている。
# そのため、すべての認証で通常のRemember Me機能同様Cookieを利用して、永続認証される仕様となっている。
# 永続認証の名前の通り、認証機関は無限(Cookieの最大保存機関の20年)としているため、セキュリティ的に問題があると考え、
# 一定期間ごとにCookieに保存する認証トークンを更新する仕様にしている。
# 将来的には、同時接続デバイス数を制限するなど、何かしらセキュリティを考慮した対策を設ける必要がある。

module SessionHelper
  # 永続認証用のトークンの持続時間(分単位)
  PERMANENT_TOKEN_EXPIRED_MINITUES = 3

  # ログイン処理を行うメソッド
  def log_in(user)
    remember_user(user) unless user.remember_me_token

    session[:user_id] = user.id
    UserAuthLog.create_success_log(user)
  end

  # ユーザーがログインをしているか確かめるメソッド
  def logged_in?
    current_user.present?
  end

  # sessionのuser_idを削除するメソッド
  def log_out
    current_user&.remember_me_token&.forget
    session[:user_id] = nil
    @current_user = nil
  end

  # ログイン中のユーザーのインスタンスを生成するメソッド(稼働中のもの)
  def current_user
    if session[:user_id]
      @current_user ||= User.active.find_by(id: session[:user_id])
    elsif cookies.signed[:user_id]
      user = User.active.find_by(id: cookies.signed[:user_id])

      if user&.remember_me_token&.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # ユーザーの認証情報を永続的に記憶
  def remember_user(user)
    remember_token = User::RememberMeToken.remember(user)
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = remember_token
    register_token_keeper
  end

  # ユーザーの永続認証用のトークンを更新
  def update_remember_token
    remember_token = current_user.remember_me_token.update_token
    cookies.permanent[:remember_token] = remember_token
    register_token_keeper
  end

  # 永続認証用トークンを維持するかを判定するかのCookieを生成
  # このCookieが消えたタイミングで、永続認証用トークンを更新する。
  def register_token_keeper
    cookies[:token_keeper] = { value: 1, expires: PERMANENT_TOKEN_EXPIRED_MINITUES.minutes.from_now }
  end

  # 永続認証用トークンを更新する必要があるかの判定
  def require_token_update?
    cookies[:token_keeper].nil? && cookies.signed[:user_id].present? && cookies[:remember_token].present? && logged_in?
  end

  # 永続的セッションを破棄する
  def forget_user(user)
    user.remember_me_token&.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
    cookies.delete(:token_keeper)
  end
end
