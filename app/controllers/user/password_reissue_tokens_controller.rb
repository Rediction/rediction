class User::PasswordReissueTokensController < ApplicationController
  skip_before_action :authenticate, only: %i[new create]
  before_action :check_auth_status, only: %i[new create]

  def new
    @password_reissue_token = User::PasswordReissueToken.new
  end

  def create
    @password_reissue_token = User::PasswordReissueToken.new(password_reissue_token_params)

    @password_reissue_token.save_with_token_and_user!

    # パスワード再設定用のトークンをつけたURLを送信
    PasswordReissueTokenMailer.send_url_to_reissue(@password_reissue_token).deliver_now
  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = "もう一度やり直してください。"
    render "new"
  end

  private

  def check_auth_status
    redirect_authed_user_base_page if logged_in?
  end

  def password_reissue_token_params
    params.require(:user_password_reissue_token).permit(:email)
  end
end
