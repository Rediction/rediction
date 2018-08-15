class Admin::User::UnfreezedReasonsController < Admin::ApplicationController
  before_action :set_freezed_user, only: %i[new create]

  def new
    @unfreezed_reason = @user.unfreezed_reasons.build
  end

  def create
    @unfreezed_reason = @user.unfreezed_reasons.build(allow_params)
    @unfreezed_reason.save_and_lift_user_freeze!

    redirect_to admin_user_path(@user), flash: { success: "ユーザーの凍結を解除しました。" }
  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = "ユーザーの凍結の解除に失敗しました。"
    render "new"
  end

  private

  # user_idに該当する凍結中のユーザーをインスタンスに格納
  def set_freezed_user
    @user = ::User.freezed.find(params[:user_id])
  end

  def allow_params
    params.require(:user_unfreezed_reason).permit(:description)
  end
end
