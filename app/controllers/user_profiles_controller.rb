class UserProfilesController < ApplicationController
  before_action :verify_provisional_user_existence, only: [:new]

  def new
    @user_profile = UserProfile.new
  end

  def create

  end

  private

    # 同じ検証用トークンで本会員になったユーザーが存在するか検証するメソッド
    def verify_provisional_user_existence
      # TODO(shuji ota):時間制限の処理を追加する
      @provisional_user = ProvisionalUser.find_by(verification_token: params[:verification_token])

      return redirect_to new_provisional_users_path, alert: "認証に失敗しました。登録しなおしてください" if @provisional_user.nil?
      member = User.find_by(email: @provisional_user.email, password_digest: @provisional_user.password_digest)

      # TODO(shuji ota):ログイン画面が完成したら遷移先をnew_provisional_users_pathからログイン画面へ変更する
      return redirect_to new_provisional_users_path, alert: "このユーザーはすでに存在します。ログインしてください。" unless member.nil?
      User.complete_member_registration(@provisional_user)
    end
end
