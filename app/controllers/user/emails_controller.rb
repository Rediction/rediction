class User::EmailsController < ApplicationController
  def edit
  end

  def update

    if current_user.same_email?(user_email_params[:email])
      flash.now[:error] = "このメールアドレスはすでに登録済みのメールアドレスです。"
      return render "edit"
    end

    current_user.update_with_changes!(user_email_params)
    redirect_to user_mypage_path, flash: { success: "メールアドレスを更新しました。" }
  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = "メールアドレスの更新に失敗しました。"
    render "edit"
  end

  private

    def user_email_params
      params.require(:user).permit(:email)
    end
end
