class User::PasswordsController < ApplicationController
  def edit
  end

  def update
    unless current_user.authenticate(user_password_params[:current_password])
      flash.now[:error] = "現在登録中のパスワードが間違っています。"
      return render "edit"
    end

    if user_password_params[:current_password] == user_password_params[:password]
      flash.now[:error] = "新しいパスワードには、現在登録中でないものを入力してください。"
      return render "edit"
    end

    current_user.update_with_changes!(password: user_password_params[:password],
                                      password_confirmation: user_password_params[:password_confirmation])

    redirect_to user_mypage_path, flash: { success: "パスワードを更新しました。" }
  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = "パスワードの更新に失敗しました。"
    render "edit"
  end

  private

    def user_password_params
      params.require(:user).permit(:current_password, :password, :password_confirmation)
    end
end
