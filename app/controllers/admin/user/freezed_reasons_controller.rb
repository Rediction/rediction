class Admin::User::FreezedReasonsController < Admin::ApplicationController
  before_action :set_unfreezed_user, only: %i[new create]

  def new
    @freezed_reason = @user.freezed_reasons.build
  end

  def create
    @freezed_reason = @user.freezed_reasons.build(allow_params)
    @freezed_reason.save_and_freeze_user!

    redirect_to admin_user_path(@user), flash: { success: "ユーザーを凍結しました。" }
  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = "ユーザーの凍結に失敗しました。"
    render "new"
  end

  private

  # user_idに該当する稼働中のユーザーをインスタンスに格納
  def set_unfreezed_user
    @user = ::User.unfreezed.find(params[:user_id])
  end

  def allow_params
    params.require(:user_freezed_reason).permit(:description)
  end
end
