class Admin::SessionsController < Admin::ApplicationController
  skip_before_action :authenticate

  def create
    admin_user = Admin::User.authenticate_by_google_omniauth_info!(request.env["omniauth.auth"])

    log_in(admin_user)

    redirect_to admin_dashboard_path, flash: { success: "管理画面にログインしました。" }
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_root_path, flash: { error: "認証に失敗しました。" }
  end

  def destroy
    log_out
    redirect_to admin_root_path, flash: { success: "ログアウトしました。" }
  end
end
