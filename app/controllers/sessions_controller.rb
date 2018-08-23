class SessionsController < ApplicationController
  skip_before_action :authenticate, only: %i[new create]
  before_action :check_auth_status, only: %i[new create]

  def new
    @user = User.new
  end

  # TODO(shuji ota):ログイン用のformクラスを作成して、それを利用するように改修する
  # ログイン処理を行うメソッド
  def create
    # paramsで取得したメールアドレスからユーザーを特定する
    user = User.find_by(email: user_params[:email])

    if user.nil?
      @user = User.new(email: user_params[:email])
      flash.now[:error] = "メールアドレスが間違っています。"
      return render "new"
    end

    # paramsで取得したパスワードが正しいかを判断する
    if user.authenticate(user_params[:password])
      log_in(user)

      redirect_to index_scoped_favorite_words_words_path, flash: { success: "ログインしました。" }
    else
      # TODO(shuji ota):パスワードを規定数間違えた時にuserをfreezeさせるようにする
      flash.now[:error] = "パスワードが間違っています。"
      UserAuthLog.create_failure_log(user)
      @user = User.new(email: user_params[:email])
      render "new"
    end
  end

  # ログアウト処理を行うメソッド
  def destroy
    log_out
    redirect_to new_login_path, flash: { success: "ログアウトしました。" }
  end

  private

  def check_auth_status
    redirect_authed_user_base_page if logged_in?
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
