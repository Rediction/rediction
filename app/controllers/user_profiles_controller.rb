class UserProfilesController < ApplicationController
  before_action :check_if_user_has_profile, only: %i[new create]

  def new
    @user_profile = UserProfile.new
  end

  def create
    # user_profilesテーブルと_changesテーブルにデータを格納する
    UserProfile.save_with_changes!(user_profile_params: user_profile_params, current_user_id: @current_user.id)

    # TODO(shuji ota):画面の遷移先をタイムラインの画面に変更する
    redirect_to root_path, flash: { success: "プロフィール登録が完了しました。" }
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:error] = e.message
    @user_profile = UserProfile.new(user_profile_params)
    render "new"
  end

  private

    def user_profile_params
      params.require(:user_profile).permit(:last_name, :last_name_kana, :first_name, :first_name_kana, :birth_on, :job)
    end

    # ユーザーの初回プロフィール入力の有無を確かめるメソッド
    def check_if_user_has_profile
      # TODO(shuji ota):画面の遷移先をプロフィール編集画面に変更する。
      redirect_to root_path if UserProfile.exists?(user_id: @current_user.id)
    end
end
