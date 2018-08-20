class UserProfilesController < ApplicationController
  before_action :check_if_user_has_profile, only: %i[new create]

  def new
    @profile = current_user.build_profile
  end

  def create
    # user_profilesテーブルと_changesテーブルにデータを格納
    @profile = current_user.build_profile(user_profile_params)
    @profile.save_with_changes!

    redirect_to index_scoped_favorite_words_words_path, flash: { success: "プロフィールを登録しました。" }
  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = "プロフィールの登録に失敗しました。"
    render "new"
  end

  def edit
    @profile = current_user.profile
  end

  def update
    @profile = current_user.profile
    @profile.update_with_changes!(user_profile_params)

    redirect_to user_mypage_path, flash: { success: "プロフィールを更新しました。" }
  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = "プロフィールの更新に失敗しました。"
    render "edit"
  end

  private

    def user_profile_params
      params.require(:user_profile)
            .permit(:last_name, :last_name_kana, :first_name, :first_name_kana, :birth_on, :job)
    end

    # ユーザーの初回プロフィール入力の有無を確かめるメソッド
    def check_if_user_has_profile
      redirect_to edit_user_profile_path if current_user.profile.present?
    end
end
