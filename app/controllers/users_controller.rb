class UsersController < ApplicationController
  skip_before_action :authenticate, only: %i[create]

  # 他ユーザーの詳細ページ
  def show
    # ログイン中のユーザーと同じidが指定されている場合はマイページにリダイレクト
    return redirect_to user_mypage_path if current_user.id == params[:id].to_i

    @user = User.find(params[:id])
  end

  # 会員登録の処理を行うメソッド
  def create
    # TODO(shuji ota):時間制限の処理を追加する
    # URLについてるトークンから仮会員の情報を取得する
    provisional_user = ProvisionalUser.find_by(verification_token: params[:verification_token])

    # 検証用トークンが不正な場合、エラーメッセージを表示して会員登録画面へ遷移させる
    if provisional_user.nil?
      return redirect_to new_signup_path, flash: { error: "不正なURLです。登録をしなおしてください。" }
    end

    # 仮会員のemailが本会員として登録済みの場合は、ログイン画面へ遷移させる
    if provisional_user.signed_up_email?
      flash[:error] = "このメールアドレスはすでに登録済みです。\nログインしてください。"
      return redirect_to new_login_path
    end

    # ユーザーの本会員登録を完了させる
    user = User.complete_member_registration!(provisional_user)

    # ユーザーのログイン処理を行う
    log_in(user)

    redirect_to new_user_profile_path
  rescue ActiveRecord::RecordInvalid
    # 本会員登録に失敗した場合、会員登録画面へ画面を遷移させる
    redirect_to new_signup_path, flash: { error: "登録に失敗しました。もう一度やり直してください。"}
  end
end
