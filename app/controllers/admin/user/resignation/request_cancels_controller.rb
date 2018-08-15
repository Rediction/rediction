class Admin::User::Resignation::RequestCancelsController < Admin::ApplicationController
  before_action :set_resigned_user, only: %i[new create]

  def new
    @request_cancel = @user.resignation_request_cancels.build
  end

  def create
    @request_cancel = @user.resignation_request_cancels.build(allow_params)
    @request_cancel.save_and_cancel_resign_request!

    redirect_to admin_user_path(@user), flash: { success: "退会処理をキャンセルしました。" }
  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = "退会処理のキャンセルに失敗しました。"
    render "new"
  end

  private

  # user_idに該当する退会済みのユーザーをインスタンスに格納
  def set_resigned_user
    @user = ::User.resigned.find(params[:user_id])
  end

  def allow_params
    params.require(:user_resignation_request_cancel).permit(:description)
  end
end
