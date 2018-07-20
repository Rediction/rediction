class UsersController < ApplicationController

  def create
    @provisional_user = ProvisionalUser.find_by(id: params[:id])
    if @provisional_user.verification_token == params[:verification_token]
      @user = User.new(user_params)
      @user.save
      redirect_to "/user_profiles/new"
    else
      redirect_to  "/provisional_user/new"
    end
  end

  def index
  end

  private

    def user_params
      params.require(:user).permit(:email, :password_digest)
    end

end