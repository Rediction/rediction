class Admin::User::Resignation::RequestsController < Admin::ApplicationController
  before_action :set_unresigned_user, only: %i[new create]

  def index
    @requests = ::User::Resignation::Request.joins(:user)
                                           .where(users: { resigned: true })
                                           .page(params[:page])
                                           .per(20)
                                           .order(id: :desc)
  end

  def new
    @request = @user.resignation_requests.build
  end

  def create
    @request = @user.resignation_requests.build(allow_params)
    @request.save_and_resign_user!

    redirect_to admin_user_path(@user), flash: { success: "ユーザーを退会させました。" }
  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = "ユーザーの退会処理に失敗しました。"
    render "new"
  end

  private

  # user_idに該当する退会していないユーザーをインスタンスに格納
  def set_unresigned_user
    @user = ::User.unresigned.find(params[:user_id])
  end

  def allow_params
    params.require(:user_resignation_request).permit(:description)
  end
end
