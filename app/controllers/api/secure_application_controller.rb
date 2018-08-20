class Api::SecureApplicationController < ActionController::Base
  before_action :authenticate

  private

  # ユーザー認証を行うメソッド
  def authenticate
    # TODO (Shokei Takanashi)
    # 現時点だとAPI側でないところで格納されたセッションを利用しており、API側と密結合な実装となっているため、
    # JWTなどを利用して、API側のみで認証できる仕組みにする。
    raise 404 if session[:user_id].blank?
  end
end
