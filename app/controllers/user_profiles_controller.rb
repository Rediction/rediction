class UserProfilesController < ApplicationController
  before_action :complete_user_registration, only: [:new]

  def new
    @user_profile = UserProfile.new
  end

  def create

  end

  private

    # ユーザーの本会員登録を完了させるメソッド
    def complete_user_registration
      @provisional_user = ProvisionalUser.find_by(verification_token: params[:verification_token])

      return render text: "認証に失敗しました。登録しなおしてください。" unless @provisional_user
      User.save_provisional_user_completion_log(@provisional_user)
    end
end
