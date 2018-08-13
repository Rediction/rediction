class Admin::UsersController < Admin::ApplicationController
  def index
    @users = ::User.page(params[:page]).per(20).order(id: :desc)
  end

  def show
    @user = ::User.find(params[:id])
  end
end
