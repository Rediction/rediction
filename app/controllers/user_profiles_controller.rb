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

      if @provisional_user
        user = User.create(email: @provisional_user.email, password_digest: @provisional_user.password_digest)
        User.save_provisional_user_completion_log(user, @provisional_user)
        UserAuthLog.certification_success_log(user)
      else
        render "new"
      end
    end
end
