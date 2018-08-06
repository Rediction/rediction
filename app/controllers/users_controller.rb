class UsersController < ApplicationController
  before_action :verify_user_login_status, only: [:create]
  skip_before_action :authenticate, only: [:create]

  # 会員登録の処理を行うメソッド
  def create
    # TODO(shuji ota):時間制限の処理を追加する
    # URLについてるトークンから仮会員の情報を取得する
    provisional_user = ProvisionalUser.find_by(verification_token: params[:verification_token])

    # 検証用トークンが不正な場合、エラーメッセージを表示して会員登録画面へ遷移させる
    if provisional_user.nil?
      return redirect_to new_provisional_users_path, flash: { error: "不正なURLです。登録をしなおしてください。" }
    end

    # TODO(shuji ota):ログインページにredirect先を変更する
    # インスタンスに格納されてるemailがすでにuserに登録されてるものかどうかを判定し、重複している場合、会員登録画面へ遷移させる
    if provisional_user.signedup_email?
      flash[:error] = "このメールアドレスはすでに登録済みです。ログインしてください。"
      return redirect_to new_provisional_users_path
    end

    # ユーザーの本会員登録を完了させる
    user = User.member_registration!(provisional_user)

    # ユーザーのログイン処理を行う
    log_in(user)

    # 会員登録の処理を行った後に、初回プロフィール入力画面へ遷移させる
    redirect_to new_user_profiles_path

  rescue ActiveRecord::RecordInvalid

    # ユーザーが存在しない場合、会員登録画面へ画面を遷移させる
    redirect_to new_provisional_users_path, flash: { error: "登録に失敗しました。もう一度やり直してください。"}
  end

  private

    # ユーザーのログインステータスを確認するメソッド
    def verify_user_login_status
      # sessionにuser_idが格納されているかを検証し、格納されている場合会員プロフィール入力画面へ遷移させる
      redirect_to new_user_profiles_path if logged_in?
    end
end
