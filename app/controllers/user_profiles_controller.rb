class UserProfilesController < ApplicationController
  before_action :process_registration, only: [:new]

  def new
    @user_profile = UserProfile.new
  end

  def create

  end

  private

    # 会員登録の処理を行うメソッド
    def process_registration
      # TODO(shuji ota):時間制限の処理を追加する
      # URLについてるトークンから仮会員の情報を取得する
      provisional_user = ProvisionalUser.find_by(verification_token: params[:verification_token])

      # 検証用トークンが不正な場合、エラーメッセージを表示して会員登録画面へ遷移させる
      if provisional_user.nil?
        return redirect_to new_provisional_users_path, flash: { error: "不正なURLです。登録をしなおしてください。" }
      end

      # TODO(shuji ota):ログインページにredirect先変える
      # インスタンスに格納されてるemailがすでにuserに登録されてるものかどうかを判定し、重複している場合、会員登録画面へ遷移させる
      if User.signuped_email?(provisional_user)
        flash[:error] = "このメールアドレスはすでに登録済みです。ログインしてください。"
        return redirect_to new_provisional_users_path
      end

      # ユーザーの本会員登録を完了させる
      user = User.complete_registration(provisional_user)

      # ユーザーが存在しない場合、会員登録画面へ画面を遷移させる
      unless user
        return redirect_to new_provisional_users_path, flash: { error: "登録に失敗しました。もう一度やり直してください。"}
      end

      # ユーザーのログイン処理を行う
      log_in(user)
    end
end
