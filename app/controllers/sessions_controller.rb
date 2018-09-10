class SessionsController < ApplicationController
  skip_before_action :authenticate, only: %i[new create]
  before_action :check_auth_status, only: %i[new create]

  def new
    @login_form = User::LoginForm.new
  end

  # ログイン処理を行うメソッド
  def create
    @login_form = User::LoginForm.new(login_form_params)

    if @login_form.authenticate
      log_in(@login_form.user)

      flash[:success] = "ログインしました。"
      redirect_authed_user_base_page
    else
      # TODO(shuji ota):パスワードを規定数間違えた時にuserをfreezeさせるようにする
      UserAuthLog.create_failure_log(@login_form.user) if @login_form.user

      flash.now[:error] = "メールアドレスまたはパスワードが正しくありません。"
      render "new"
    end
  end

  # ログアウト処理を行うメソッド
  def destroy
    log_out if logged_in?
    redirect_to new_login_path, flash: { success: "ログアウトしました。" }
  end

  private

  def check_auth_status
    redirect_authed_user_base_page if logged_in?
  end

  def login_form_params
    params.require(:user_login_form).permit(:email, :password)
  end
end
