class User::PasswordReissuesController < ApplicationController
  skip_before_action :authenticate, only: %i[new create]
  before_action :check_auth_status, only: %i[new create]
  before_action :check_token_validity

  def new
    @password_reissue_form = User::PasswordReissueForm.new(token: params[:token])
  end

  def create
    @password_reissue_form = User::PasswordReissueForm.new(password_reissue_params)

    # パスワード再設定
    @password_reissue_form.save!

    # ログイン
    password_reissue_token = User::PasswordReissueToken.find_by!(token: @password_reissue_form.token)
    log_in(password_reissue_token.user)

    redirect_to index_latest_order_words_path, flash: { success: "パスワードの再設定が完了しました。" }
  rescue ActiveRecord::RecordInvalid, ActiveModel::ValidationError
    flash[:error] = "パスワードの再設定に失敗しました。"
    render "new"
  end

  private

  def check_auth_status
    redirect_authed_user_base_page if logged_in?
  end

  def password_reissue_params
    params.require(:user_password_reissue_form).permit(:password, :password_confirmation, :token)
  end

  # トークンの有効性(利用可能かどうか)を確認
  def check_token_validity
    unless User::PasswordReissueToken.available_token?(params[:token])
      raise ExceptionHandlers::NotFound
    end
  end
end
