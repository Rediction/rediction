class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new

  end

  def create(user)

    @user = User.new(user_params)
    if @user.save
      redirect_to("users/index")
    else
      render("users/new")
    end

  end

private

  def user_params
    params.permit(:name,:email)
  end

end