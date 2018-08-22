class ProvisionalUsersController < ApplicationController
  skip_before_action :authenticate, only: %i[new create]
  before_action :check_auth_status, only: %i[new create]

  def new
    @provisional_user = ProvisionalUser.new
  end

  def create
    @provisional_user = ProvisionalUser.new(provisional_user_params)

    if @provisional_user.save_with_verification_token
      # ユーザー認証を行い、本会員登録を完了させるためのメール
      ProvisionalUserRegistrationMailer.send_when_registration(@provisional_user).deliver_now
    else
      flash.now[:error] = "仮会員登録に失敗しました。"
      render "new"
    end
  end

  private

  def check_auth_status
    redirect_authed_user_base_page if logged_in?
  end

  def provisional_user_params
    params.require(:provisional_user).permit(:email, :password)
  end
end
