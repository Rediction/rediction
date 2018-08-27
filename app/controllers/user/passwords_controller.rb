class User::PasswordsController < ApplicationController
  def edit
  end

  def update
    unless current_user.authenticate(params[:user][:current_password])
      flash.now[:error] = "現在登録中のパスワードが間違っています。"
      return render "edit"
    end

    current_user.update_with_changes!(user_password_params)

    redirect_to user_mypage_path, flash: { success: "パスワードを更新しました。" }
  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = "パスワードの更新に失敗しました。"
    render "edit"
  end

  private

    def user_password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
