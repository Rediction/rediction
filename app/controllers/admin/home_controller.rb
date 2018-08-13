class Admin::HomeController < Admin::ApplicationController
  skip_before_action :authenticate

  def index
    # ログイン済みの場合は、ダッシュボードにリダイレクトする
    redirect_to admin_dashboard_path if logged_in?
  end
end
