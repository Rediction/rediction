class UserProfilesController < ApplicationController
  before_action :check_if_user_has_profile, only: %i[new create]

  def new
    @user_profile = current_user.build_profile
  end

  def create
    # user_profilesテーブルと_changesテーブルにデータを格納する
    @user_profile = current_user.build_profile(user_profile_params)

    # TODO(shuji ota):画面の遷移先をタイムラインの画面に変更する
    redirect_to root_path, flash: { success: "プロフィール登録が完了しました。" }
  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = "プロフィール登録に失敗しました。"
    render "new"
  end

  private

    def user_profile_params
      params.require(:user_profile).permit(:last_name, :last_name_kana, :first_name, :first_name_kana, :birth_on, :job)
    end

    # ユーザーの初回プロフィール入力の有無を確かめるメソッド
    def check_if_user_has_profile
      # TODO(shuji ota):画面の遷移先をプロフィール編集画面に変更する。
      redirect_to root_path if current_user.profile.present?
    end
end
